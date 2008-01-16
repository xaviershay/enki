# Test for facets/kernel/metaid

require 'facets/kernel/metaid.rb'

require 'test/unit'

class TCKernel < Test::Unit::TestCase

  def test_metaclass
    o = Object.new
    assert_equal( (class << o; self; end), o.metaclass )
  end

  def test_meta_class
    o = Object.new
    assert_equal( (class << o; self; end), o.meta_class )
  end

  def test_singleton
    o = Object.new
    assert_equal( (class << o; self; end), o.singleton )
  end

  #def test_singleton_eval
  #  assert_nothing_raised do
  #    o.singleton_class_eval{ @@a = "test" }
  #  end
  #end

  #def test_singleton_method
  #  assert_nothing_raised do
  #    o.define_singleton_method(:testing){ |x| x + 1 }
  #  end
  #  assert_equal(2, o.testing(1) )
  #end

  def test_singleton_Class
    o = Object.new
    assert_equal( (class << o; self; end), o.singleton_class )
  end

  def test_qua_class
    o = Object.new
    assert_equal( (class << o; self; end), o.qua_class )
  end

end
