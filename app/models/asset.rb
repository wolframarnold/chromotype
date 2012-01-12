class Asset < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :asset_uris
  scope :with_tag, lambda { |tag| includes(:tags).where("tags.id" => tag.id) }
  scope :with_tag_or_descendants, lambda { |tag| includes(:tags => [:ancestors]).where("ancestors_tags.id = ? or tags.id = ?", tag.id, tag.id) }
  scope :with_uri, lambda { |uri| includes(:uris).where("uris.sha" => AssetUri.sha(uri)) }

  def self.process_roots
    Settings.roots.each{ |root| AssetProcessor.new(root).process }
  end

  def self.can_process? uri
    false
  end

  def thumbprints
    []
  end
end
