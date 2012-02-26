require "minitest_helper"

describe AssetProcessor do
  before :each do
    p = Pathname.new("test/images/IMG_2452.jpg")
    @asset = AssetProcessor.new(nil).process(p)
    @asset.save!
    @path = p.realpath
    @uri = @path.to_uri.to_s
  end

  def assert_path
    @asset.uri.must_equal(@path.to_uri)
    @asset.asset_uris.size.must_equal 1
    au = @asset.asset_uris.first
    au.to_uri.must_equal(@path.to_uri)
    au.uri.must_equal(@path.to_uri.to_s)
  end

  it "should work on insert" do
    assert_path
  end

  it "should find the prior asset" do
    a2 = AssetProcessor.new(nil).process(@path)
    a2.must_equal(@asset)
  end
end

