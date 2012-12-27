class AssetUrn < ActiveRecord::Base
  belongs_to :asset_url

  scope :with_urn, lambda { |urn|
    where(:urn => urn).first
  }

  scope :with_any_urn, lambda { |urns|
    where(:urn => urns)
  }
end