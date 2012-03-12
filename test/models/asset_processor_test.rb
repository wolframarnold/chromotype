require "minitest_helper"

describe AssetProcessor do
  before :each do
    p = Pathname.new("test/images/IMG_2452.jpg")
    @ap = AssetProcessor.new(nil)
    @asset = @ap.process(p)
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
    a2 = @ap.process(@path)
    a2.must_equal(@asset)
  end

  it "should return false for non-exif-encoded assets" do
    @ap.process("test/images/simple.png").must_be_nil
  end

  it "should skip processing JPG assets without EXIF headers" do
    @ap.process("test/images/simple.jpg").must_be_nil
  end

  it "should skip processing URIs that don't exist'" do
    @ap.process("test/images/zzz.jpg").must_be_nil
  end

  it "should process JPG assets with EXIF headers" do
    ea = @ap.process("test/images/Canon 20D.jpg")
    ea.wont_be_nil
    ea.reload.tags.collect { |t| t.ancestry_path.join("/") }.sort.must_equal [
      "when/2004/9/19",
        "when/seasons/autumn",
        "with/Canon/Canon EOS 20D",
        "file" + (Rails.root + "test/images").to_s
    ].sort

  end

  it "should process GPS-tagged asset" do
    ea = @ap.process("test/images/iPhone 4S.jpg")
    ea.reload.tags.collect { |t| t.ancestry_path.join("/") }.sort.must_equal [
      "when/2011/11/23",
        "when/seasons/autumn",
        "with/Apple/iPhone 4S",
        "where/Earth/North America/United States/California/San Mateo County/El Granada",
        "file" + (Rails.root + "test/images").to_s
    ].sort
  end

  it "should create resized image assets"
end
