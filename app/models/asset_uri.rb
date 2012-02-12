class AssetUri < ActiveRecord::Base
  belongs_to :asset
  validates_presence_of :uri
  before_save :normalize_uri_and_sha

  def normalize_uri_and_sha
    nuri = self.uri.to_uri.normalize
    self.uri = nuri.to_s
    self.sha = self.class.sha(nuri)
  end

  scope :with_uri, lambda { |uri|
    where(:sha => sha(uri)).order("created_at DESC")
  }

  scope :with_filename, lambda { |filename|
    where("asset_uris.sha = ?", sha_for_filename(filename))
  }

  scope :with_any_filename, lambda { |filenames|
    where("asset_uris.sha" => filenames.collect { |ea| sha_for_filename(ea) })
  }

  def to_uri
    @uri ||= self.uri.to_uri
  end

  def self.sha(uri)
    Digest::SHA2.hexdigest(uri.to_uri.normalize.to_s)
  end

  def self.sha_for_filename(filename)
    sha(URI.from_file(filename))
  end
end
