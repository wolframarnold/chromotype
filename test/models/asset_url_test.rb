require "minitest_helper"

describe AssetUrl do
  it "should normalize file URIs properly" do
    url = "file:///a/b/c"
    au = AssetUrl.create!(:url => url)
    au.reload.url.must_equal(url)
  end

  it "should find by filename" do
    au1 = AssetUrl.create!(:url => "file:///a/b/c")
    au2 = AssetUrl.create!(:url => "file:///d/e/f")
    AssetUrl.with_filename("/a/b/c").to_a.must_equal([au1])
    AssetUrl.with_filename("/d/e/f").to_a.must_equal([au2])
    AssetUrl.with_any_filename(["/d/e/f", "/g/h/i"]).to_a.must_equal([au2])
    AssetUrl.with_any_filename(["/g/h/i"]).to_a.must_equal([])
    AssetUrl.with_any_filename(["/g/h/i", "/a/b/c"]).to_a.must_equal([au1])
    AssetUrl.with_any_filename(["/g/h/i", Pathname.new("/a/b/c"), "/d/e/f"]).to_a.must_equal([au1, au2])
  end
end
