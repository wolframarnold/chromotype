class Asset < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :asset_uris, :order => 'id desc', :dependent => :destroy
  scope :with_tag, lambda { |tag| includes(:tags).where("tags.id" => tag.id) }
  scope :with_tag_or_descendants, lambda { |tag| includes(:tags => [:ancestors]).where("ancestors_tags.id = ? or tags.id = ?", tag.id, tag.id) }
  scope :with_uri, lambda { |uri| includes(:uris).where("uris.sha" => AssetUri.sha(uri)) }

  def uri
    asset_uris.first.uri
  end

  def uri= uri
    uri = URI.normalize(uri)
    asset_uris.find_by_uri(uri) || asset_uris.build(:uri => uri)
  end

  def thumbprints
    []
  end
end
