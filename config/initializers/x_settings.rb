ActiveSupport.on_load(:active_record) do
  h = ENV["HOME"]

  # Note that library_root is always added to roots.

  Settings.defaults[:roots] = %w{Pictures Movies Documents Public public_html}.inject([]) do |a, type|
    ["#{h}/#{type}", "#{h}/My #{type}"].each do |f|
      if File.directory? f
        a << f
      else
        f = f.downcase
        a << f if File.directory? f
      end
    end
    a
  end

  # Normally use locally-spun delayed job daemons. Switch this to :no_op or :heroku to install on a server.
  Settings.defaults[:hirefire_environment] = :local
  Settings.defaults[:hirefire_min_workers] = 1
  Settings.defaults[:hirefire_max_workers] = Parallel.processor_count

  Settings.defaults[:library_root] = File.join h, *case RbConfig::CONFIG['host_os']
                                        when /darwin|linux|freebsd/
                                          "Pictures/Chromotype Library"
                                        when /mswin|mingw/
                                          ["My Pictures", "Chromotype Library"]
                                      end
  # TODO Settings.defaults[:copy_to_library] = :with_hardlink # or :with_mv, :with_symlink or :never
  # TODO Settings.defaults[:duplicate_directory] = File.join h, "Duplicates"
  # TODO Settings.defaults[:move_duplicates] = false # set to true to move duplicates into dupe purgatory

  # TODO Settings.defaults[:library_originals] = File.join "Originals", "%Y", "%m", "%d"
  # TODO Settings.defaults[:ignorable_patterns] = %w{Thumbs/ Previews/ tmp/}
  # TODO Settings.defaults[:minimum_image_pixels] = 1024*620

  # TODO Settings.defaults[:library_cache] = "Cache/%Y/%m/"

  # TODO: determine this automatically by geoip against this host's public IP address
  Settings.defaults[:is_northern_hemisphere] = true # <-- used for seasons tagging
  
end
