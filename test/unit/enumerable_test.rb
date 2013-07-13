require "test_helper"

describe Enumerable do
  it "collects for array from hash results" do
    [1, 2, 3].
      collect_hash { |i| {i.to_s => i} }.
      must_equal("1" => 1, "2" => 2, "3" => 3)
  end
  it "collects for array from array results" do
    [:a, :b, :c].
      collect_hash { |i| [i.to_s, i] }.
      must_equal("a" => :a, "b" => :b, "c" => :c)
  end
  it "collects for hash from hash results" do
    {:a => 1, :b => 2, :c => 3}.
      collect_hash { |k, v| {k => v + 1} }.
      must_equal(:a => 2, :b => 3, :c => 4)
  end
  it "collects for hash from array results" do
    {:a => 1, :b => 2, :c => 3}.
      collect_hash { |k, v| [k, v + 1] }.
      must_equal(:a => 2, :b => 3, :c => 4)
  end
  it "skips nil yield results properly" do
    {:a => 1, :b => 2, :c => 3, :d => 4}.
      collect_hash { |k, v| [k, v] if v % 2 == 0 }.
      must_equal(:b => 2, :d => 4)
  end
end
