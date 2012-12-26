class AssetUrn < ActiveRecord::Base
  has_and_belongs_to_many :asset_urls

  scope :with_urn, lambda { |urn|
    where(:urn => urn).first
  }

  scope :with_any_urn, lambda { |urns|
    where(:urn => urns)
  }
end