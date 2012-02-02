ActiveSupport.on_load(:active_record) do

  class Settings
    def self.default_roots(home=ENV["HOME"])
      home = Pathname.new(home) unless home.is_a? Pathname
      roots = %w{Pictures Movies Documents Public public_html}.collect do |type|
        Dir.glob((home + "*#{type}").to_s, File::FNM_CASEFOLD)
      end
      roots.flatten!
      roots.select { |r| File.directory? r }
    end
  end

  Settings.defaults[:roots] = Settings.default_roots

  # Normally use locally-spun delayed job daemons. Switch this to :no_op or :heroku to install on a server.
  Settings.defaults[:hirefire_environment] = :local
  Settings.defaults[:hirefire_min_workers] = 1
  Settings.defaults[:hirefire_max_workers] = Parallel.processor_count
  Settings.defaults[:mini_magick_processor] = 'gm'

  Settings.defaults[:library_root] = File.join(ENV["HOME"], *case RbConfig::CONFIG['host_os']
    when /darwin|linux|freebsd/
      ["Pictures", "Chromotype Library"]
    when /mswin|mingw/
      ["My Pictures", "Chromotype Library"]
  end)

  # TODO Settings.defaults[:duplicate_directory] = File.join h, "Duplicates"
  # TODO Settings.defaults[:move_duplicates] = false # set to true to move duplicates into dupe purgatory

  # TODO Settings.defaults[:library_originals] = File.join "Originals", "%Y", "%m", "%d"
  # TODO Settings.defaults[:ignorable_patterns] = %w{Thumbs/ Previews/ tmp/}
  # TODO Settings.defaults[:minimum_image_pixels] = 1024*620

  # TODO: determine this automatically by geoip against this host's public IP address
  Settings.defaults[:is_northern_hemisphere] = true # <-- used for seasons tagging

  class Settings

    def self.roots
      [library_root] + self[:roots]
    end

    def self.library_root
      r = Pathname.new self[:library_root]
      r.mkpath unless r.exist?
      r
    end

    def self.cache_dir_for_date(date)
      (library_root + date.strftime("Cache/%Y/%m/")).tap { |p| p.mkpath }
    end

    require 'nokogiri'
    require 'open-uri'

    # Yeah, I'm going to hell for this, but it's just to be nice to the user, so it's OK.
    def self.latitude_maxmind
      doc = Nokogiri::HTML(open('http://www.maxmind.com/app/locate_my_ip'))
      doc.xpath('//td[contains(text(), "Latitude")]/following-sibling::td').text.split("/").first.strip
    end

    def self.latitude_geoiptool
      doc = Nokogiri::HTML(open('http://www.geoiptool.com/en/'))
      doc.xpath('//span[text()="Latitude:"]/../../td[2]').text
    end

    def self.latitude
      latitude_maxmind
    rescue StandardError
      begin
      latitude_geoiptool
      rescue StandardError
      nil
        end
    end

    def self.is_northern_hemisphere
      self[:is_northern_hemisphere] || begin
        l = latitude
        if l.nil?
          true
        else
          self[:is_northern_hemisphere] = l.to_f > 0
        end
      end
    end
  end
end

