class NextFileProcessor
  include Sidekiq::Worker

  def self.for_directory(directory)
    f = Findler.new directory
    f.append_extensions ExifAsset.FILE_EXTENSIONS
    f.case_insensitive!
    f.exclude_hidden!
    f.add_filters :skip_exclusion_patterns, :exif_only
    new(f.iterator)
  end

  # This enqueues at most 64 files to be processed,
  # then re-enqueues itself for more processing.
  def perform(directory)
    iterator =
      if directory.respond_to? :next_file
        directory
      else
        for_directory(directory)
      end
    next_file = nil
    (1..256).each do # the 256 could be any value > 1, but bigger numbers mean the iterator has to be serialized fewer times.
      next_file = iterator.next_file
      break if next_file.nil? # no more files in the directory!
      AssetProcessor.perform_async(next_file.to_uri.to_s)
    end
    self.class.perform_async(iterator) if next_file
  end
end