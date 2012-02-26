require "minitest_helper"

describe Settings do
  it "should find our latitude" do
    lat = Settings.latitude
    lat.wont_be_nil
    lat.to_f.wont_be_close_to(0, 1)
  end
end
