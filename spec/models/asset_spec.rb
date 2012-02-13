require "spec_helper.rb"

describe Asset do
  before :each do
    @asset = Asset.asset_for_file("Gemfile")
    @asset.save!
    @path = Pathname.new("Gemfile").realpath
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

  it "should find with_filename(pathname)" do
    Asset.with_filename(@path).to_a.should == [@asset]
  end

  it "should find with_uri(pathname)" do
    Asset.with_uri(@path.to_uri).to_a.should == [@asset]
  end

  it "should find with_filename(to_s)" do
    Asset.with_filename(@path.to_s).to_a.should == [@asset]
  end

  it "should find the prior asset" do
    a2 = Asset.asset_for_file("Gemfile")
    a2.should == @asset
  end

  it "should be a no-op on Asset.uri= with existing uri" do
    @asset.uri = Pathname.new("Gemfile")
    @asset.save!
    assert_path
    @asset.uri = @path
    @asset.save!
    assert_path
  end

  it "should add another #uri=" do
    u = "https://s3.amazonaws.com/test/test/Gemfile"
    @asset.uri = u
    @asset.save!
    @asset.reload.should have(2).asset_uris
    au = @asset.asset_uris.first
    au.uri.should == u
    @asset.asset_uris.second.uri.should == @uri
  end

  it "should fail to give the same URI to another asset" do
    a = Asset.create!
    lambda { a.uri = Pathname.new("Gemfile") }.should raise_error(ArgumentError)
  end

  # TODO? it "should delegate to proper Asset class methods to process a URI"

end

