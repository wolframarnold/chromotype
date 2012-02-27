require "minitest_helper"

describe AssetUri do
  before :each do
    AssetUri.delete_all
  end

  it "should normalize file URIs properly" do
    au = AssetUri.new
    uri = "file:/a/b/c"
    au.uri = uri
    au.save
    au.reload.uri.must_equal(uri)
  end

  it "should find by filename" do
    au1 = AssetUri.create!(:uri => "file:/a/b/c")
    au2 = AssetUri.create!(:uri => "file:/d/e/f")
    AssetUri.with_filename("/a/b/c").to_a.must_equal([au1])
    AssetUri.with_filename("/d/e/f").to_a.must_equal([au2])
    AssetUri.with_any_filename(["/d/e/f", "/g/h/i"]).to_a.must_equal([au2])
    AssetUri.with_any_filename(["/g/h/i"]).to_a.must_equal([])
    AssetUri.with_any_filename(["/g/h/i", "/a/b/c"]).to_a.must_equal([au1])
    AssetUri.with_any_filename(["/g/h/i", Pathname.new("/a/b/c"), "/d/e/f"]).to_a.must_equal([au1, au2])
  end
end
