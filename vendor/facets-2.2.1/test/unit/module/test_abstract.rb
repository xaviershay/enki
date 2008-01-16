# Test for facets/module/abstract

require 'facets/module/abstract.rb'

require 'test/unit'

class TestAttrTester < Test::Unit::TestCase

  class Aq
    abstract :q
  end

  def test_abstract_01
    ac = Aq.new
    assert_raises( TypeError ) { ac.q }
  end

  def test_abstract_02
    ac = Class.new { abstract :q }.new
    assert_raises( TypeError ) { ac.q }
  end

end
