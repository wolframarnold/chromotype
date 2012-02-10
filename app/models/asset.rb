class Asset < ActiveRecord::Base
  has_many :asset_tags
  has_many :tags, :through => :asset_tags
  has_many :asset_uris, :order => 'id desc', :dependent => :destroy

  PROCESSORS = Hash.new { |h, k| h[k] = [] }

  def self.add_processor_method_for_extnames(method, extnames)
    extnames.each do |ea|
      ea = ea.downcase.ensure_prefix(".") unless ea.nil?
      PROCESSORS[ea] << method
    end
  end

  def self.normalized_extname filename
    p = filename.is_a?(Pathname) ? filename : Pathname.new(filename)
    extname = p.extname
    extname ? extname.downcase : nil
  end

  def self.process_file filename
    PROCESSORS[normalized_extname(filename)].find { |ea| ea.call(filename) }
  end

  #TODO:DELETE
  #scope :with_tag, lambda { |tag| includes(:tags).where("tags.id" => tag.id) }
  #scope :with_tag_or_descendants, lambda { |tag| includes(:tags => [:ancestors]).where("ancestors_tags.id = ? or tags.id = ?", tag.id, tag.id) }

  def self.with_uri(uri)
    joins(:asset_uris) & AssetUri.with_uri(uri)
  end

  def self.with_tag(tag)
    joins(:asset_tags) && AssetTag.find_by_tag_id(tag.id)

  def self.with_filename(filename)
    joins(:asset_uris) & AssetUri.with_filename(filename)
  end

  def self.with_any_filename(filenames)
    joins(:asset_uris) & AssetUri.with_any_filename(filenames)
  end

  def uri
    asset_uris.first.try(:uri)
  end

  def uri= uri
    asset_uris.with_uri(uri).first || asset_uris.build(:uri => uri)
  end

  def deleted!
    update_attribute(:deleted, true)
  end

  def thumbprints
    []
  end
end
