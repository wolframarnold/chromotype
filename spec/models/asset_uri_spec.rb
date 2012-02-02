require "spec_helper.rb"

describe AssetUri do
  it "should normalize file URIs properly" do
    au = AssetUri.new
    au.uri = "/hello"
  end
end
