# Test for facets/kernel/object

require 'facets/kernel/object.rb'

require 'test/unit'

class TCKernel < Test::Unit::TestCase

  def test_object_class
    assert_equal( self.class, self.object_class )
  end

  def test_object_hexid
    o = Object.new
    assert( o.inspect.index( o.object_hexid ) )
  end

  def test__class__
    assert_equal( self.class, self.__class__ )
  end

end
