ActiveSupport.on_load(:active_record) do
  h = ENV["HOME"]
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

  Settings.defaults[:embedded_worker_threads] = 1

  # Sleep this number of seconds between background tasks
  Settings.defaults[:naptime_between_tasks] = 0.5
  Settings.defaults[:library_root] = File.join(h, "Pictures/Chromotype Library")

  # TODO: determine this automatically by geoip against this host's public IP address
  Settings.defaults[:is_northern_hemisphere] = true
end
