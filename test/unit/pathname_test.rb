require "minitest_helper"

describe Pathname do

  describe "path_array" do
    it "should split paths properly" do
      Pathname.new("/a/b/c").path_array.must_equal(%w{a b c})
    end
  end

  describe "follow_redirects" do
    it "should follow relative symlinks" do
      with_tmp_dir do |dir|
        `ln -s c b`
        `ln -s b a`
        a = Pathname.new('a')
        c = Pathname.new('c')
        a.follow_redirects.must_be_nil
        c.follow_redirects.must_be_nil
        `touch c`
        c.follow_redirects.must_equal([c.realpath])
        a = a.follow_redirects
        a.collect { |ea| ea.basename.to_s }.must_equal(%w(a b c))
        p = Pathname.new(dir).realpath
        a.must_equal(%w(a b c).collect { |ea| p + ea })
      end
    end
  end

  describe "absolutepath" do
    it "should work with simple files" do
      p = Pathname.new "Gemfile"
      p.absolutepath.must_equal(p.realpath)
    end
    it "should work with non-existent paths from real paths" do
      p = Pathname.new "a/b/c"
      p.absolutepath.must_equal(Rails.root + p)
    end
    it "should work with symlinks" do
      with_tmp_dir do |dir|
        `ln -s b a`
        p = Pathname.new "b"
        # even though it doesn't exist
        p.absolutepath.must_equal(Pathname.new(dir).realpath + "b")
      end
    end
  end
end
