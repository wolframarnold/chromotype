require "spec_helper.rb"

describe AssetProcessor do
  before :each do
    p = Pathname.new("spec/images/IMG_2452.jpg")
    @asset = AssetProcessor.new(nil).process(p)
    @asset.save!
    @path = p.realpath
    @uri = @path.to_uri.to_s
  end

  def assert_path
    @asset.uri.should == @path.to_uri
    @asset.should have(1).asset_uris
    au = @asset.asset_uris.first
    au.to_uri.should == @path.to_uri
    au.uri.should == @path.to_uri.to_s
  end

  it "should work on insert" do
    assert_path
  end

  it "should find the prior asset" do
    a2 = AssetProcessor.new(nil).process(@path)
    a2.should == @asset
  end
end

