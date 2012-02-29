class AssetThumbprint < ActiveRecord::Base
  belongs_to :asset

  validates_presence_of :thumbprint

  scope :with_thumbprint, lambda { |thumbprint|
    where(if thumbprint.is_a?(AssetThumbprint)
      { :type => thumbprint.type,
        :thumbprint => thumbprint.thumbprint }
    else
      { :thumbprint => thumbprint.to_s }
    end)
  }

  def self.mk_sha1(array)
    array.collect { |ea| ea.to_s }.join(":").to_sha1
  end
end
