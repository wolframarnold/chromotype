require "spec_helper.rb"

describe ExifAsset do
  it "should return false for non-exif-encoded assets" do
    ExifAsset.process_file("spec/sample-images/simple.png").should be_nil
  end
  it "should skip processing JPG assets without EXIF headers" do
    ExifAsset.process_file("spec/sample-images/simple.jpg").should be_nil
  end
  it "should skip processing URIs that don't exist'" do
    ExifAsset.process_file("spec/sample-images/xxx.jpg").should be_nil
  end
  it "should process JPG assets with EXIF headers" do
    ea = ExifAsset.process_exif("spec/sample-images/Canon 20D.jpg")
    ea.should_not be_nil
    ea.tags.collect{|t|t.ancestry_path.join("/")}.should =~ [
      ea.uri,
      "when/2010/03/23",
      "when/Winter",
      "with/Canon/Canon EOS 20D",
    ]
  end
end
