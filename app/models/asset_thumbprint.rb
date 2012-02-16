class AssetThumbprint < ActiveRecord::Base
  belongs_to :asset
  validates_presence_of :thumbprint

  scope :with_any_thumbprint, lambda { |thumbprints|
    where(:thumbprint => thumbprints)
  }

  def self.mk_sha(array)
    array.collect{|ea|ea.to_s}.join(":").to_sha2
  end
end
