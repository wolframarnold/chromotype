require "minitest_helper"

describe URN::Exif do

  it "should find a resized asset from Preview.app as equivalent" do
    orig_urn = URN::Exif.urn_for_pathname(img_path("Canon 20D.jpg"))
    resized_urn = URN::Exif.urn_for_pathname(img_path("Canon 20D-small.jpg"))
    orig_urn.must_equal resized_urn
  end

  it "should find a recolored asset from Picasa as equivalent" do
    orig_urn = URN::Exif.urn_for_pathname(img_path("IMG_2452.jpg"))
    resized_urn = URN::Exif.urn_for_pathname(img_path("IMG_2452_picasa.jpg"))
    orig_urn.must_equal resized_urn
  end
end
