class AssetTag < ActiveRecord::Base
  belongs_to :asset
  belongs_to :tag
end
