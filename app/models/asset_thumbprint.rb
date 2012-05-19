class AssetThumbprint < ActiveRecord::Base
  belongs_to :asset
  validates_presence_of :thumbprint
  attr_accessible :thumbprint, :type

  def self.to_hash(thumbprint)
    if thumbprint.is_a?(AssetThumbprint)
      { :type => thumbprint.type,
        :thumbprint => thumbprint.thumbprint }
    else
      { :thumbprint => thumbprint.to_s }
    end
  end

  scope :with_thumbprint, lambda { |thumbprint|
    where(to_hash(thumbprint))
  }

  scope :with_any_thumbprint, lambda { |thumbprints|
    # Can't use a simple array here in the where clause because type may be different.
    # scoped.or to the rescue:
    thumbprints.inject(scoped) do |thumbprint|
      scoped.or.where(to_hash(thumbprint))
    end
  }
end
