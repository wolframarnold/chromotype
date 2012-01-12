require "spec_helper.rb"

describe Settings do
  it "should find our latitude" do
    lat = Settings.latitude
    lat.should_not be_nil
    lat.to_f.should_not == 0
  end
end