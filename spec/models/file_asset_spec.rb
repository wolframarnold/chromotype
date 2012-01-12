require "spec_helper.rb"

describe FileAsset do

  def with_temp_photos(&block)
    with_tmp_dir do |dir|
      `cp -r #{Rails.root + "spec/sample-images"} .`
      yield dir
    end
  end

  it "should deactivate a FileAsset that no longer exists" do
    with_temp_photos do |dir|
      Settings.roots = [dir]
      Asset.process(dir)
    end
  end
end