class Asset < ActiveRecord::Base
  has_many :asset_tags
  has_many :tags, :through => :asset_tags
  has_many :asset_uris, :order => 'id desc', :dependent => :destroy

  # "Importers" take a URI and (possibly) return an asset. This is a global.
  IMPORTERS = Hash.new { |h, k| h[k] = [] }

  def self.add_importer(method, extnames)
    extnames.each do |ea|
      ea = ea.downcase.ensure_prefix(".") unless ea.nil?
      IMPORTERS[ea] << method
    end
  end

  # "Processors" take an asset and do something with it -- tagging, resizing, ...
  PROCESSORS = []

  def self.add_processor(method)
    PROCESSORS << method
  end

  def self.normalized_extname filename
    filename.to_pathname.extname.try(:downcase)
  end

  def self.import_file filename
    filename = filename.to_pathname
    IMPORTERS[normalized_extname(filename)].find { |ea| ea.call(filename) }
  end
  
  scope :with_tag, lambda { |tag|
    joins(:asset_tags).merge(AssetTag.find_by_tag_id(tag.id))
  }

  #scope :with_tag_or_descendants, lambda { |tag| includes(:tags => [:ancestors]).where("ancestors_tags.id = ? or tags.id = ?", tag.id, tag.id) }

  scope :with_uri, lambda { |uri|
    joins(:asset_uris).merge AssetUri.with_uri(uri)
  }

  scope :with_any_filename, lambda { |filenames|
    joins(:asset_uris).merge(AssetUri.with_any_filename(filenames))
  }

  scope :with_filename, lambda { |filename|
    joins(:asset_uris).merge(AssetUri.with_filename(filename))
  }

  def pathname
    uri.pathname
  end

  def captured_at
    pathname.ctime
  end

  def uri
    asset_uris.first.try(:to_uri)
  end

  def uri= uri
    return unless asset_uris.with_uri(uri).empty?
    # Do I need to steal the uri from another asset?
    dupes = AssetUri.with_uri(uri)
    raise ArgumentError, "Asset #{dupes.first.asset.id} already points to #{uri}" unless dupes.empty?
    asset_uris.build(:uri => uri)
  end

  def delete!
    update_attribute(:deleted_at, Time.now)
  end

  def thumbprints
    []
  end

  def process
    PROCESSORS.each{|ea|ea.call(self)}
  end

  def add_tag(tag)
    asset_tags.find_by_tag_id(tag.id) || asset_tags.create(:tag_id => tag.id)
  end

  def self.asset_for_file(filename, allowable_extensions = nil)
    filename = filename.to_pathname
    paths = filename.follow_redirects
    if paths.nil?
      # the file has been deleted, so mark the assets accordingly
      with_filename(filename).each { |ea| ea.delete! }
      return true
    end

    if allowable_extensions
      path = paths.last
      suffix = path.extname.strip_prefix(".")
      return false unless allowable_extensions.include? suffix
    end

    # first adopt the asset if there is one...
    assets = with_any_filename(paths)
    if assets.size > 1
      paths_to_s = paths.collect { |ea| ea.to_s }.join ","
      raise ArgumentError, "Multiple assets found with paths: #{paths_to_s}"
    end

    asset = assets.first || self.new
    paths.each { |ea| asset.uri = ea.to_uri }
    asset
  end

end
