require "spec_helper.rb"

describe AssetUri do
  it "should normalize file URIs properly" do
    au = AssetUri.new
    uri = "file:/a/b/c"
    au.uri = uri
    au.save
    au.reload.uri.should == uri
  end

  it "should find by filename" do
    au1 = AssetUri.create!(:uri => "file:/a/b/c")
    au2 = AssetUri.create!(:uri => "file:/d/e/f")
    AssetUri.with_filename("/a/b/c").to_a.should == [au1]
    AssetUri.with_filename("/d/e/f").to_a.should == [au2]
    AssetUri.with_any_filename(["/d/e/f", "/g/h/i"]).to_a.should == [au2]
    AssetUri.with_any_filename(["/g/h/i"]).to_a.should == []
    AssetUri.with_any_filename(["/g/h/i", "/a/b/c"]).to_a.should == [au1]
    AssetUri.with_any_filename(["/g/h/i", Pathname.new("/a/b/c"), "/d/e/f"]).to_a.should =~ [au1, au2]
  end
end
