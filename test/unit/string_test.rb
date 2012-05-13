require "minitest_helper"

describe String do
  it "makes sha" do
    "hello world".sha.must_equal("2aae6c35c94fcfb415dbe95f408b9ce91ee846ed")
  end

end
