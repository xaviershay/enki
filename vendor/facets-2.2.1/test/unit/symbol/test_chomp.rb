# Test for lib/facets/symbol/chomp

require 'facets/symbol/chomp.rb'

require 'test/unit'

class TestSymbol < Test::Unit::TestCase

  def test_chomp
    assert_equal( :a, :ab.chomp(:b) )
  end

  def test_lchomp
    assert_equal( :b, :ab.lchomp(:a) )
  end

end
