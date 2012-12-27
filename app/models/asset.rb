class Asset < ActiveRecord::Base
  include ExifMixin

  belongs_to :original_asset, :class_name => "Asset"
  has_many :derivatives, :class_name => "Asset", :foreign_key => "original_asset_id"
  has_many :asset_tags
  has_many :tags, :through => :asset_tags
  has_many :asset_urls, :order => 'id desc', :dependent => :destroy
  has_many :asset_urns, :through => :asset_urls
  has_many :asset_thumbprints, :order => 'id desc', :dependent => :destroy

  scope :with_tag, lambda { |tag|
    joins(:asset_tags).merge(AssetTag.find_by_tag_id(tag.id))
  }

  scope :with_tag_or_descendents, lambda { |tag|
    joins(:asset_tags).
      joins("join #{Tag.hierarchy_table_name} on asset_tags.tag_id = #{Tag.hierarchy_table_name}.descendant_id").
      where("#{Tag.hierarchy_table_name}.ancestor_id = ?", tag.id)
  }

  #scope :with_tag_or_descendants, lambda { |tag| includes(:tags => [:ancestors]).where("ancestors_tags.id = ? or tags.id = ?", tag.id, tag.id) }

  scope :with_url, lambda { |uri|
    joins(:asset_urls).merge AssetUrl.with_uri(uri)
  }

  def self.without(instance)
    scope.where(["#{quoted_table_name}.#{self.class.primary_key} != ?", instance.id])
  end

  scope :with_filename, lambda { |filename|
    joins(:asset_urls).
      merge(AssetUrl.with_filename(filename)).
      readonly(false)
  }

  scope :with_any_filename, lambda { |filenames|
    joins(:asset_urls).
      merge(AssetUrl.with_any_filename(filenames)).
      readonly(false)
  }

  scope :find_by_urn, lambda { |urn|
    joins(:asset_urls => :asset_urns).
      merge(AssetUrn.with_urn(urn)).
      readonly(false)
  }

  scope :with_any_urn, lambda { |urn|
    joins(:asset_urls => :asset_urns).
      merge(AssetUrn.with_any_urn(urns)).
      readonly(false)
  }

  def with_same_thumbprints
    scoped.with_any_thumbprint(asset_thumbprints).without(self)
  end

  scope :deleted, where("#{table_name}.deleted_at IS NOT NULL")
  scope :not_deleted, where("#{table_name}.deleted_at IS NULL")

  def pathname
    @pathname ||= begin
      au = asset_urls.detect { |ea| ea.exist? } || asset_urls.detect { |ea| ea.pathname }
      au.pathname if au
    end
  end

  def captured_at
    pathname.ctime
  end

  def url
    asset_urls.first.try(:to_uri)
  end

  def add_pathname(pathname)
    asset_urls.find_or_create_by_url(pathname.to_pathname.to_uri.to_s)
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
    save
  end

  def add_tag(tag)
    asset_tags.find_or_create_by_tag_id(tag.id)
  end

  def add_thumbprint(asset_thumbprint)
    asset_thumbprints.find_or_create_by_type_and_thumbprint(
      :type => asset_thumbprint.class,
      :thumbprint => asset_thumbprint.thumbprint)
  end

  def move_to_library
    return unless Settings.move_to_library

    # If one already is in the originals directory, it wins.
    with_same_thumbprints.select do |ea|
      ea.pathname.child_of? Settings.library_root
    end.each do |ea|
      if contents_match?(ea) &&
        Settings.move_dupes_to_trash
        Rails.logger.warn("Moving dupe file #{pathname} into the trash. It's the same as #{ea.pathname}.")
        pathname.mv_to_trash
        return
      end
    end

    move_to_originals
    winner.original_asset = nil
    winner.save!
    others.each do |ea|
      ea.move_to_derivatives
      ea.original_asset = winner
      ea.save!
    end
  end

  def move_to_originals
    mv_to(Settings.originals_root)
  end

  def move_to_derivatives
    mv_to(Settings.derivatives_root)
  end

  def move_to_trash
    pathname.mv_to_trash
  end

  def mv_to(basedir)
    dest = basedir + ymd_dirs + pathname.basename
    FileUtils.mv(pathname, dest)
  end
end
