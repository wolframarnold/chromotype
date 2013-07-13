#expected comment
require "test_helper"

describe URI::File do
  before :each do
    @file_uri = URI.parse("file://#{__FILE__}")
  end

  it "hooks into URI.parse" do
    @file_uri.class.must_equal URI::File
  end

  it "works to_pathname" do
    @file_uri.to_pathname.to_s.must_equal __FILE__.to_s
  end

  it "works with read" do
    @file_uri.read.must_match /^#expected comment/
  end
end
