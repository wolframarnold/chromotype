class AssetUri < ActiveRecord::Base
  belongs_to :asset
  validates_presence_of :uri
  before_save :normalize_uri_and_sha
  attr_accessible :uri

  def normalize_uri_and_sha
    self.uri = self.uri.to_uri.normalize.to_s
    self.uri_sha = self.uri.sha
  end

  # Will be nil unless the uri's scheme is "file"
  def pathname
    @pathname ||= to_uri.pathname
  end

  def exist?
    pathname && pathname.exist?
  end

  def self.sha_for_uri(uri)
    uri.to_uri.normalize.to_s.sha
  end

  scope :find_by_uri, lambda { |uri|
    where(:uri_sha => sha_for_uri(uri)).first
  }

  def self.sha_for_filename(filename)
    filename.to_pathname.to_uri.to_s.sha
  end

  scope :with_filename, lambda { |filename|
    where(:uri_sha => sha_for_filename(filename)).first
  }

  scope :with_any_filename, lambda { |filenames|
    where(:uri_sha => filenames.collect { |ea| sha_for_filename(ea) })
  }

  def to_uri
    @uri ||= self.uri.to_uri
  end

end
