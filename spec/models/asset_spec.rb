require "spec_helper.rb"

describe Asset do
  context :one_uri_creation do
    before :each do
      @ea = ExifAsset.new
      @ea.uri = "Gemfile"
      @ea.save!
      @path = (Rails.root + "Gemfile").to_s
    end

    def assert_path
      @ea.uri.should == "file:" + @path
      @ea.should have(1).asset_uris
      au = @ea.asset_uris.first
      au.uri.should == "file:" + @path
    end

    it "should assign a new asset_uri on a new asset with #uri=" do
      assert_path
    end

    it "should be a no-op if #uri= points to the same file" do
      @ea.uri = "Gemfile"
      @ea.save!
      assert_path
      @ea.uri = @path
      @ea.save!
      assert_path
    end

    it "should add another #uri=" do
      @ea.uri = "Gemfile.lock"
      @ea.save!
      @ea.should have(2).asset_uris
      au = @ea.asset_uris.first
      au.uri.should == "file:" + @path + ".lock"
    end
  end
  #maybe? it "should delegate to proper Asset class methods to process a URI"

end
