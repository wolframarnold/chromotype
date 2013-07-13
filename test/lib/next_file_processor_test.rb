require "test_helper"

describe NextFileProcessor do
  it "should filter files properly" do
    NextFileProcessor.new.perform("test")
    actual = AssetProcessor.jobs.collect { |ea| ea["args"].first.to_pathname.basename.to_s }
    expected = (Dir["test/images/*"].collect { |ea| ea.to_pathname.basename.to_s }) - [
      "simple.jpg",
      "simple.png",
      "warning.png",
      "Canon 20D-small.jpg"
    ]
    actual.must_equal_contents expected
  end
end
