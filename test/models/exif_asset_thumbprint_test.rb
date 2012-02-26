require "minitest_helper"

def exifa(path)
  ExifAssetThumbprint.exif_thumbprint_array(ExifAsset.exif("test/images/#{path}"))
end

describe ExifAssetThumbprint do
  it "should find a resized asset from Preview.app as equivalent" do
    exifa("Canon 20D.jpg").must_equal(exifa("Canon 20D-small.jpg"))
  end

  it "should find a recolored asset from Picasa as equivalent" do
    a = exifa("IMG_2452.jpg")
    a.should_not be_empty
    a.must_equal(exifa("IMG_2452_picasa.jpg"))
  end
end
