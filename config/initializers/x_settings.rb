ActiveSupport.migration_safe_on_load do

  Settings.cache = ActiveSupport::Cache::MemoryStore.new
  Settings.cache_options = { :expires_in => 5.minutes }

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
  #Settings.defaults[:mini_magick_processor] = 'gm'

  host_os = RbConfig::CONFIG['host_os']
  prefix = host_os =~ /mswin|mingw/ ? "My " : ""

  Settings.defaults[:library_root] = File.join(
    ENV["HOME"],
    "#{prefix}Pictures",
    "Chromotype"
  )

  # TODO Settings.defaults[:duplicate_directory] = File.join h, "Duplicates"
  # TODO Settings.defaults[:move_duplicates] = false # set to true to move duplicates into dupe purgatory

  # TODO Settings.defaults[:library_originals] = File.join "Originals", "%Y", "%m", "%d"
  # TODO Settings.defaults[:ignorable_patterns] = %w{Thumbs/ Previews/ tmp/}
  Settings.defaults[:minimum_image_pixels] = 1024*768
  Settings.defaults[:resizes] = %w{
    2560x1600
    1920x1080
    1280x720
    640x360
    320x180
    160x90
  }

  Settings.defaults[:square_crop_sizes] = [128, 64]

  # TODO: determine this automatically by geoip against this host's public IP address
  Settings.defaults[:is_northern_hemisphere] = true # <-- used for seasons tagging

  class Settings

    def self.roots
      [library_root] + self[:roots]
    end

    def self.library_root
      self[:library_root].to_pathname.tap{|d|d.mkpath}
    end

    Settings.defaults[:cache_dir] = Settings.library_root + ".cache"

    def self.resizes
      sort_dimensions(self[:resizes])
    end

    def self.square_crop_sizes
      self[:square_crop_sizes].sort.reverse
    end

    def self.sort_dimensions(dimensions)
      dimensions.sort_by do |a|
        a.split(/[^\d]/).first(2).inject(1) { |p, i| p * i.to_i }
      end.reverse
    end

    require 'nokogiri'
    require 'open-uri'

    # Yeah, I'm going to geek hell for the xpaths, but it's just to be nice to the user, so it's OK.
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

