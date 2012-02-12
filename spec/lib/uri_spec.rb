require "spec_helper.rb"

describe URI do
  it "should make absolute paths from non-relative paths for files" do
    u = URI.from_file("Gemfile")
    u.scheme.should == "file"
    u.path.should == (Rails.root + "Gemfile").to_s
    u.pathname.is_a?(Pathname).should be_true
    u.to_s.should == "file:" + u.path
  end

  it "should round-trip" do
    u1 = URI.from_file("Gemfile")
    u2 = URI.parse(u1.to_s)
    u2.pathname.should == u1.pathname
  end
end
