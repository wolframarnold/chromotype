require "spec_helper.rb"

describe File do
  it "should follow relative symlinks" do
    with_tmp_dir do |dir|
      `touch c`
      `ln -s c b`
      `ln -s b a`
      p = Pathname.new(dir)
      File.follow_redirects(p + "a").should == %w(a b c).collect{|ea| (p + ea).to_s}
    end
  end
end

