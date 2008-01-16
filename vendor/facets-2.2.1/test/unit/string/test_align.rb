# Test for lib/facets/string/align.rb

require 'facets/string/align.rb'

require 'test/unit'

class TestStringAlign < Test::Unit::TestCase

  def test_align_right
    assert_equal( "      xxx", "xxx".align_right(9) )
  end

  def test_align_left
    assert_equal( "xxx      ", "xxx".align_left(9) )
  end

  def test_align_center
    assert_equal( "   xxx   ", "xxx".align_center(9) )
  end

end

