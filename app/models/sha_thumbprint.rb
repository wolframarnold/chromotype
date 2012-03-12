class ShaThumbprint < AssetThumbprint
  attr_accessible :thumbprint
  def self.thumbprint(pathname, ignored)
    new(:thumbprint => Digest::SHA2.file(pathname).hexdigest)
  end
end
