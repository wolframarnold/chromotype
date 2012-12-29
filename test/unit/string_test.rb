require "minitest_helper"

describe String do
  it "sha1s properly" do
    # http://en.wikipedia.org/wiki/SHA-1#Example_hashes
    "The quick brown fox jumps over the lazy dog".sha1.
      must_equal("2fd4e1c67a2d28fced849ee1bb76e7391b93eb12")
  end
end
