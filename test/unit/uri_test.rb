require "test_helper"

describe URI do
  it "should make absolute paths from non-relative paths for files" do
    u = URI.from_file("Gemfile")
    u.scheme.must_equal("file")
    u.path.must_equal((Rails.root + "Gemfile").to_s)
    u.to_pathname.must_be_kind_of(Pathname)
    u.to_s.must_equal("file://" + u.path)
  end

  it "should round-trip" do
    u1 = URI.from_file("Gemfile")
    u2 = URI.parse(u1.to_s)
    u2.to_pathname.must_equal(u1.to_pathname)
  end
end
