ActiveSupport.migration_safe_on_load do

  # Note that all these settings are defaults -- the user can override them
  # persistently in the database.

  class Settings
    self.cache = ActiveSupport::Cache::MemoryStore.new
    self.cache_options = {:expires_in => 5.minutes}

    def self.windows?
      RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
    end

    # The library root holds the imported original, duplicate, and thumbnail assets.

    def self.default_library_root
      prefix = windows? ? "My " : ""
      ENV["HOME"].to_pathname + "#{prefix}Pictures" + "Chromotype"
    end

    defaults[:library_root] = default_library_root

    def self.library_root
      self[:library_root].to_pathname.ensure_directory
    end

    def self.cache_root
      (library_root + "Caches").ensure_directory
    end

    def self.thumbnail_root
      (library_root + "Thumbnails").ensure_directory
    end

    # The "roots" are directories that are scanned for assets to import.

    def self.default_roots(home = ENV["HOME"])
      home = home.to_pathname
      roots = %w{Pictures Movies Documents Public public_html}.collect do |type|
        Dir.glob((home + "*#{type}").to_s, File::FNM_CASEFOLD)
      end
      roots.flatten!
      roots.select { |r| File.directory? r }
    end

    defaults[:roots] = Settings.default_roots

    def self.resized_root
      (library_root + "Resized").ensure_directory
    end

    def self.masters_root
      (library_root + "Masters").ensure_directory
    end

    def self.roots
      # If people edit files in the originals or duplicates roots, we should see it.
      (self[:roots] + [masters_root]).uniq
    end

    def self.keys
      defaults.keys + Settings.pluck(:var)
    end

    # If set, assets found outside of the library root will be moved into originals or modified
    defaults[:move_to_library] = false
    defaults[:move_dupes_to_trash] = false

    defaults[:exclusion_patterns] = %w(cache caches previews secret temp thumbs tmp)

    defaults[:minimum_image_pixels] = 1024*768 # minimum .7mp image

    defaults[:resizes] = %w{
      1920x1080
      1280x720
      640x360
      320x180
      160x90
    }

    # iPhoto uses 640x480 and 360x270 (?)

    # Do you want to store "Firstname Lastname",
    # or "Firstname/Lastname" for face tags?
    # (See FaceTag)
    defaults[:split_face_names] = true

    # Do you want "lastname/firstname", or "firstname/lastname"?
    # (See FaceTag)
    defaults[:reverse_face_paths] = true

    # Common screen resolutions:
    # 1280 x 720  (720p)
    # 1366 x 768  (11" MBA)
    # 1280 x 800  (Nexus 7)
    # 1440 x 900  (13" MBA)
    # 1920 x 1080 (1080p, 21" iMac)
    # 1920 x 1200 (17" MBP)
    # 2560 x 1440 (27" iMac)
    # 2048 x 1536 (iPad 3)
    # 2560 x 1600 (Nexus 10)
    # 2560 x 1600 (30" LCD) -- but by adding this resolution, we double the time
    # it takes to process an image.

    defaults[:square_crop_sizes] = [320, 64]

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

    # Used for seasons tagging. This is expensive, so we only do it once
    # and save it, rather than just setting a default.
    if self[:is_northern_hemisphere].nil?
      self[:is_northern_hemisphere] = IpLocation.northern_hemisphere? || true
    end

    def self.magick_engine=(engine)
      if setup_micromagick(engine)
        Settings["magick_engine"] = engine
      end
    end

    def self.setup_micromagick(engine = magick_engine)
      begin
        MicroMagick.use(engine)
      rescue MicroMagick::InvalidArgument => e
        Rails.logger.warn("MicroMagick doesn't support using '#{engine}'")
        false
      end
    end

    self.setup_micromagick
  end
end
