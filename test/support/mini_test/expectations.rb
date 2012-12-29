module MiniTest::Expectations
  infect_an_assertion :assert_contents_equal, :must_equal_contents
  infect_an_assertion :assert_contains_all, :must_contain_all
  infect_an_assertion :assert_true, :must_be_true
  infect_an_assertion :assert_truthy, :must_be_truthy
  infect_an_assertion :assert_false, :must_be_false
  infect_an_assertion :assert_falsy, :must_be_falsy
  infect_an_assertion :refute_truthy, :wont_be_truthy
  infect_an_assertion :refute_falsy, :wont_be_falsy
end

