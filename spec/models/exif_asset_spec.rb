require "spec_helper.rb"

describe ExifAsset do
  it "should return false for non-exif-encoded assets" do
    ExifAsset.import_file("spec/images/simple.png").should be_nil
  end
  it "should skip processing JPG assets without EXIF headers" do
    ExifAsset.import_file("spec/images/simple.jpg").should be_nil
  end
  it "should skip processing URIs that don't exist'" do
    ExifAsset.import_file("spec/images/xxx.jpg").should be_nil
  end
  it "should process JPG assets with EXIF headers" do
    ea = ExifAsset.import_exif_file("spec/images/Canon 20D.jpg")
    ea.should_not be_nil
    ea.reload.tags.collect { |t| t.ancestry_path.join("/") }.should =~ [
      "when/2004/9/19",
        "when/seasons/autumn",
        "with/Canon/Canon EOS 20D",
        "file" + (Rails.root + "spec/images").to_s
    ]
  end
  it "should process GPS-tagged asset" do
    ea = ExifAsset.import_exif_file("spec/images/iPhone 4S.jpg")
    ea.reload.tags.collect { |t| t.ancestry_path.join("/") }.should =~ [
      "when/2011/11/23",
        "when/seasons/autumn",
        "with/Apple/iPhone 4S",
        "where/Earth/North America/United States/California/San Mateo County/El Granada",
        "file" + (Rails.root + "spec/images").to_s
    ]
  end
end
