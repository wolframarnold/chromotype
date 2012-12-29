require "minitest_helper"

describe Asset do
  before :each do
    @asset = Asset.create!
    @path = "Gemfile".to_pathname.realpath
    @asset.add_pathname @path
    @url = @path.to_uri.to_s
  end

  def assert_path
    @asset.asset_urls.collect { |ea| ea.url }.must_equal [@url]
    au = @asset.asset_urls.first
    au.to_uri.must_equal(@path.to_uri)
    au.url.must_equal(@path.to_uri.to_s)
  end

  it "should work on insert" do
    assert_path
  end

  it "should set basename properly" do
    @asset.reload.basename.must_equal("Gemfile")
  end

  it "should find with_filename(pathname)" do
    Asset.with_any_filename([@path]).to_a.must_equal([@asset])
  end

  it "should find with_url(pathname)" do
    Asset.with_url(@path.to_uri).to_a.must_equal([@asset])
  end

  it "should find with_filename(to_s)" do
    Asset.with_any_filename([@path.to_s]).to_a.must_equal([@asset])
  end

  it "should be a no-op on Asset.uri= with existing uri" do
    @asset.add_pathname Pathname.new("Gemfile")
    @asset.save!
    assert_path
    asset_urls.find_or_create_by_url(@path)
    @asset.save!
    assert_path
  end

  it "should add another #uri=" do
    u = "https://s3.amazonaws.com/test/test/Gemfile"
    @asset.add_url(u)
    @asset.reload.asset_urls.collect { |ea| ea.url }.must_equal [u, @url]
    au = @asset.asset_urls.first
    au.url.must_equal(u)
    @asset.asset_urls.second.url.must_equal(@url)
  end

  it "should fail to give the same URI to another asset" do
    a = Asset.create!
    lambda { a.add_pathname Pathname.new("Gemfile") }.must_raise(ActiveRecord::RecordNotUnique)
  end
end

