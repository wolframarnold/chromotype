class ShaThumbprint < AssetThumbprint
  attr_accessible :thumbprint
  def self.thumbprint(pathname, ignored = nil)
    new(:thumbprint => pathname.to_pathname.sha)
  end
end
