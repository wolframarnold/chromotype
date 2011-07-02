require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def test_create_roots
    Tag.create_roots!
    before = Tag.all.count
    # Creating the seasons root should not add more tags:
    assert_not_nil Tag.seasons_root
    assert_equal before, Tag.all.count
  end
end
