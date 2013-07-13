class Asset < ActiveRecord::Base

  include AttrMemoizer
  attr_memoizer :pathname

  has_many :asset_urls, -> { order 'id desc' }, dependent: :destroy
  has_many :asset_urns, through: :asset_urls

  has_many :asset_tags
  has_many :tags, through: :asset_tags

  scope :with_tag, lambda { |tag|
    joins(:asset_tags).merge(AssetTag.find_by_tag_id(tag.id))
  }

  scope :with_tag_or_descendants, lambda { |tag|
    htn = Tag._ct.quoted_hierarchy_table_name
    joins(:asset_tags).
      joins("INNER JOIN #{htn} ON asset_tags.tag_id = #{htn}.descendant_id").
      where("#{htn}.ancestor_id" => tag.id)
  }

  scope :with_url, lambda { |url|
    joins(:asset_urls).merge(AssetUrl.with_url(url))
  }

  scope :with_any_url, lambda { |urls|
    joins(:asset_urls).merge(AssetUrl.with_any_url(urls))
  }

  def self.without(instance)
    scoped.where(["#{quoted_table_name}.#{self.class.primary_key} != ?", instance.id])
  end

  scope :with_filename, lambda { |filename|
    joins(:asset_urls).merge(AssetUrl.with_filename(filename))
  }

  scope :with_any_filename, lambda { |filenames|
    joins(:asset_urls).merge(AssetUrl.with_any_filename(filenames))
  }

  scope :with_urn, lambda { |urn|
    joins(:asset_urls => :asset_urns).merge(AssetUrn.with_urn(urn))
  }

  scope :with_any_urn, lambda { |urns|
    joins(:asset_urls => :asset_urns).merge(AssetUrn.with_any_urn(urns))
  }

  def self.deleted
    where("#{table_name}.deleted_at IS NOT NULL")
  end

  def self.not_deleted
    where(deleted_at: nil)
  end

  def pathname
    au = asset_urls.detect { |ea| ea.exist? } || asset_urls.detect { |ea| ea.pathname }
    au.pathname if au
  end

  def captured_at
    pathname.ctime
  end

  def add_pathname(pathname)
    asset_urls.with_url(pathname.to_pathname.to_uri).first_or_create
  end

  def add_url(url)
    asset_urls.with_url(url).first_or_create
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

  def add_tag(tag, visitor = nil)
    asset_tags.where(tag: tag).first_or_initialize.update(visitor: visitor.to_s)
  end

  def urn_siblings_in_library
    with_same_urns.select do |ea|
      ea.pathname.child_of? Setting.library_root
    end
  end

  def move_to_library
    return unless Setting.move_to_library

    # If one already is in the originals directory, it wins.
    urn_siblings_in_library.each do |ea|
      if contents_match?(ea) && Setting.move_dupes_to_trash
        Rails.logger.warn("Moving dupe file #{pathname} into the trash. It's the same as #{ea.pathname}.")
        pathname.mv_to_trash
        return
      end
    end

    move_to_masters_root
    winner.original_asset = nil
    winner.save!
    others.each do |ea|
      ea.move_to_derivatives_root
      ea.original_asset = winner
      ea.save!
    end
  end

  def move_to_masters_root
    mv_to(Setting.masters_root)
  end

  def move_to_derivatives_root
    mv_to(Setting.derivatives_root)
  end

  def move_to_trash
    pathname.mv_to_trash
  end

  def mv_to(basedir)
    dest = basedir + ymd_dirs + pathname.basename
    FileUtils.mv(pathname, dest)
  end
end
