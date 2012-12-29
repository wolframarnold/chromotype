module MiniTest::Expectations
  infect_an_assertion :assert_contents_equal, :must_equal_contents
  infect_an_assertion :assert_contains_all, :must_contain_all
end

