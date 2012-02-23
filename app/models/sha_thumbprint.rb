class ShaThumbprint < AssetThumbprint
  def self.thumbprint(pathname, ignored)
    new(:thumbprint => Digest::SHA2.file(pathname).hexdigest)
  end
end
