class AssetUrl < ActiveRecord::Base
  belongs_to :asset
  has_many :asset_urns

  validates_presence_of :url
  validates :asset, :presence => true
  validate :immutable_url
  before_create :normalize_url_and_sha
  after_save :update_asset_basename

  scope :with_filename, lambda { |filename|
    where(:url => filename.to_pathname.to_uri.to_s)
  }

  scope :with_any_filename, lambda { |filenames|
    where(:url => filenames.map { |ea| ea.to_pathname.to_uri.to_s })
  }

  # returns a Pathname instance. Will be nil unless the uri's scheme is "file"
  def pathname
    @pathname ||= to_uri.to_pathname
  end

  def basename
    pathname.basename.to_s
  end

  def exist?
    pathname && pathname.exist?
  end

  def to_uri
    @uri ||= self.url.to_uri
  end

  private

  def normalize_url_and_sha
    self.url = to_uri.normalize.to_s
    self.url_sha = self.url.to_s.sha1
  end

  def immutable_url
    if !new_record? && changed_attributes.include?(:url)
      errors.add(:url, "immutable")
    end
  end

  def update_asset_basename
    if asset.basename.nil?
      asset.update_attribute(:basename, basename)
    end
  end
end
