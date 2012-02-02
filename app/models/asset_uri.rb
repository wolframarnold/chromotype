class AssetUri < ActiveRecord::Base

  class UriMarshal
    def load(text)
      text && URI.parse(text)
    end

    def dump(text)
      text.to_s
    end
  end

  belongs_to :asset
  validate :validate_uri
  before_save :set_sha
  serialize :uri, UriMarshal.new

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
