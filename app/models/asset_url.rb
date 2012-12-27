class AssetUrl < ActiveRecord::Base
  belongs_to :asset
  has_many :asset_urns

  validates_presence_of :url
  validate :immutable_url
  before_create :normalize_url_and_sha

  scope :with_filename, lambda { |filename|
    where(:url => filename.to_pathname.to_uri.to_s)
  }

  scope :with_any_filename, lambda { |filenames|
    where(:url => filenames.map { |ea| ea.to_pathname.to_uri.to_s })
  }

  # Will be nil unless the uri's scheme is "file"
  def pathname
    @pathname ||= to_url.pathname
  end

  def exist?
    pathname && pathname.exist?
  end

  def to_uri
    @url ||= self.url.to_uri
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
end
