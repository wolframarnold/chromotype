class AssetUri < ActiveRecord::Base
  belongs_to :asset
  validates_presence_of :uri
  before_save :normalize_uri_and_sha
  attr_accessible :uri

  def normalize_uri_and_sha
    self.uri = self.uri.to_uri.normalize.to_s
    self.sha = self.uri.to_sha2
  end

  scope :with_uri, lambda { |uri|
    where(:sha => sha(uri)).order("created_at DESC")
  }

  scope :with_filename, lambda { |filename|
    where(:sha => sha_for_filename(filename))
  }

  scope :with_any_filename, lambda { |filenames|
    where(:sha => filenames.collect { |ea| sha_for_filename(ea) })
  }

  def to_uri
    @uri ||= self.uri.to_uri
  end

  def self.sha(uri)
    uri.to_uri.normalize.to_s.to_sha2
  end

  def self.sha_for_filename(filename)
    sha(filename.to_pathname)
  end
end
