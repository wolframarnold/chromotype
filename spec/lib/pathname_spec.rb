require "spec_helper.rb"

describe Pathname do
  it "should follow relative symlinks" do
    with_tmp_dir do |dir|
      `ln -s c b`
      `ln -s b a`
      a = Pathname.new('a')
      c = Pathname.new('c')
      a.follow_redirects.should be_nil
      c.follow_redirects.should be_nil
      `touch c`
      c.follow_redirects.should == [c.realpath]
      a = a.follow_redirects
      a.collect{|ea|ea.basename.to_s}.should == %w(a b c)
      p = Pathname.new(dir).realpath
      a.should == %w(a b c).collect{|ea| p + ea}
    end
  end
end
