class AssetUrl < ActiveRecord::Base
  belongs_to :asset
  has_and_belongs_to_many :asset_urns

  validates_presence_of :url
  before_create :normalize_url_and_sha

  def normalize_url_and_sha
    self.url = to_uri.normalize.to_s
    self.url_sha = self.url.to_s.sha1
  end

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

end
