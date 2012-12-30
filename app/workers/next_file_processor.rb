class NextFileProcessor
  include Sidekiq::Worker

  def to_iterator(directory_or_iterator)
    if directory_or_iterator.is_a? Findler::Iterator
      directory_or_iterator
    else
      f = Findler.new(directory_or_iterator)
      f.add_extensions ExifAsset::FILE_EXTENSIONS
      f.case_insensitive!
      f.exclude_hidden!
      f.add_filters [:skip_exclusion_patterns, :with_minimum_resolution, :exif_only]
      f.iterator
    end
  end

  # This enqueues N files to be processed, then re-enqueues itself for more processing.
  def perform(directory_or_iterator)
    iterator = to_iterator(directory_or_iterator)
    next_file = nil
    (1..256).each do # the 256 could be any value > 1, but bigger numbers mean the iterator has to be serialized fewer times.
      next_file = iterator.next_file
      break if next_file.nil? # no more files in the directory!
      puts "!!!! AssetProcessor.perform_async(#{next_file})"
      AssetProcessor.perform_async(next_file)
    end
    self.class.perform_async(iterator) if next_file
  end
end