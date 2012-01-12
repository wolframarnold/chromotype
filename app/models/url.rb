class AssetUri < ActiveRecord::Base
  belongs_to :asset
  validate :validate_uri
  before_save :set_sha

  def validate_uri
    self.uri = URI.normalize(uri).to_s
  end

  def set_sha
    self.sha = self.class.sha(uri, false)
  end

  def self.sha(uri, normalize = true)
    uri = URI.normalize(uri).to_s if normalize
    Digest::SHA2.hexdigest(uri)
  end

  def self.find_by_uri(uri)
    find_by_sha(sha(uri))
  end
end
