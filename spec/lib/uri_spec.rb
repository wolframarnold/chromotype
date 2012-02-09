require "spec_helper.rb"

describe URI do
  it "should fix non-relative paths" do
    u = URI.normalize("Gemfile")
    u.scheme.should == "file"
    u.path.should == (Rails.root + "Gemfile").to_s
  end
end
