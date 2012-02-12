class AssetUri < ActiveRecord::Base
  belongs_to :asset
  before_save :set_sha
  validates_presence_of :uri

  def self.with_uri(uri)
    where :sha => sha(uri)
  end

  def self.with_filename(filename)
    where :sha => sha_for_filename(filename)
  end

  def self.with_any_filename(filenames)
    where :sha => filenames.collect { |ea| sha_for_filename(ea) }
  end

  def set_sha
    self.sha = self.class.sha(uri, false)
  end

  def self.sha(uri, normalize = true)
    uri = URI.parse(uri) unless uri.is_a? URI
    uri.normalize! if normalize
    Digest::SHA2.hexdigest(uri.to_s)
  end

  def self.sha_for_filename(filename)
    sha(URI.from_file(filename))
  end

end
