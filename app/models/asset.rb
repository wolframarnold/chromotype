class Asset < ActiveRecord::Base
  belongs_to :original_asset, :class_name => "Asset"
  has_many :derivatives, :class_name => "Asset", :foreign_key => "original_asset_id"
  has_many :asset_tags
  has_many :tags, :through => :asset_tags
  has_many :asset_uris, :order => 'id desc', :dependent => :destroy
  has_many :asset_thumbprints, :order => 'id desc', :dependent => :destroy

  attr_accessible :uri

  scope :with_tag, lambda { |tag|
    joins(:asset_tags).merge(AssetTag.find_by_tag_id(tag.id))
  }

  scope :with_tag_or_descendents, lambda { |tag|
    joins(:asset_tags).
      joins("join #{Tag.hierarchy_table_name} on asset_tags.tag_id = #{Tag.hierarchy_table_name}.descendant_id").
      where("#{Tag.hierarchy_table_name}.ancestor_id = ?", tag.id)
  }

  #scope :with_tag_or_descendants, lambda { |tag| includes(:tags => [:ancestors]).where("ancestors_tags.id = ? or tags.id = ?", tag.id, tag.id) }

  scope :with_uri, lambda { |uri|
    joins(:asset_uris).merge AssetUri.with_uri(uri)
  }

  scope :with_filename, lambda { |filename| joins(:asset_uris).merge(AssetUri.with_filename(filename)).readonly(false) }
  scope :with_any_filename, lambda { |filenames| joins(:asset_uris).merge(AssetUri.with_any_filename(filenames)).readonly(false) }
  scope :with_thumbprint, lambda { |thumbprint| joins(:asset_thumbprints).merge(AssetThumbprint.with_thumbprint(thumbprint)).readonly(false) }
  scope :with_any_thumbprint, lambda { |thumbprints| joins(:asset_thumbprints).merge(AssetThumbprint.with_any_thumbprint(thumbprints)).readonly(false) }

  scope :deleted, where("#{table_name}.deleted_at IS NOT NULL")
  scope :not_deleted, where("#{table_name}.deleted_at IS NULL")

  def pathname
    @pathname ||= begin
      au = asset_uris.detect { |ea| ea.exist? } || asset_uris.detect { |ea| ea.pathname }
      au.pathname if au
    end
  end

  def captured_at
    pathname.ctime
  end

  def uri
    asset_uris.first.try(:to_uri)
  end

  def add_uri(uri)
    return unless asset_uris.with_uri(uri).empty?
    # Do I need to steal the uri from another asset?
    dupes = AssetUri.with_uri(uri)
    unless dupes.empty?
      raise ArgumentError, "Asset #{dupes.first.asset.id} already points to #{uri}"
    end
    asset_uris.build(:uri => uri)
  end

  def add_pathname(pathname)
    add_uri(pathname.to_pathname.to_uri)
  end

  def delete!
    update_attribute(:deleted_at, Time.now)
  end

  def deleted?
    !deleted_at.nil?
  end

  def exists?
    pathname && pathname.exists?
  end

  def lost?
    !lost_at.nil?
  end

  def sanity_check!
    if exists?
      self.lost_at = nil
    else
      self.lost_at ||= Time.now # <- only set if lost_at wasn't set already
    end
    save if changed?
  end

  def add_tag(tag)
    asset_tags.find_or_create_by_tag_id(tag.id)
  end

  def add_thumbprint(asset_thumbprint)
    asset_thumbprints.find_or_create_by_type_and_thumbprint(
      :type => asset_thumbprint.class,
      :thumbprint => asset_thumbprint.thumbprint)
  end

  def move_to_originals
    mv_to(Settings.originals_root)
  end

  def move_to_derivatives
    mv_to(Settings.derivatives_root)
  end

  def mv_to(basedir)
    dest = basedir + ymd_dirs + pathname.basename
    FileUtils.mv(pathname, dest)
  end
end
