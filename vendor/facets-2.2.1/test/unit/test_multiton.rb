require 'test/unit'
require 'facets/multiton'

#
# EXAMPLE A - STANDARD USAGE
#
class TC_Multiton_A < Test::Unit::TestCase

  class SomeMultitonClass
    include Multiton

    attr :arg
    def initialize(arg)
      @arg = arg
    end
  end

  def test_standard

    a = SomeMultitonClass.instance(4)
    b = SomeMultitonClass.instance(4)     # a and b are same object
    c = SomeMultitonClass.instance(2)     # c is a different object

    assert_equal( a, b )
    assert_equal( 42, [a.arg,b.arg].max * 10 + c.arg )

  end

end

#
# EXAMPLE B - MODIFY AN EXISTING CLASS, SHARED FILEHANDLES
#
class TC_Multiton_B < Test::Unit::TestCase

  class ::File
    include Multiton
  end

  def test_modify_existing

    lineno = __LINE__
    # HERE1
    # HERE2

    a = File.instance(__FILE__)
    b = File.instance(__FILE__)

    assert_equal( a, b )

    lineno.times{ a.gets }

    assert_equal( "# HERE1", a.gets.strip )
    assert_equal( "# HERE2", b.gets.strip )

  end

end

#
# EXAMPLE C - INHERITENCE
#
class TC_Multiton_C < Test::Unit::TestCase

  class A < String
    include Multiton
  end

  # B is also a multiton - with it's OWN object cache
  class B < A; end

  def test_inheritence

    # w is the same object as x, y is the same object as z
    w,x,y,z = A.instance('A'), A.instance('A'), B.instance('B'), B.instance('B')

    assert_equal( w.object_id, x.object_id ) # -> true
    assert_equal( y.object_id, z.object_id ) # -> true

    a = B.instance('A')
    b = B.instance('A')

    assert_not_equal( a.object_id, w.object_id ) # -> false (each class has it's own pool)
    assert_equal( a.object_id, b.object_id )     # -> true

  end

end


#
# EXAMPLE D - MULTIPLE MODULE INCLUSION (does nothing)
#
class TC_Multiton_D < Test::Unit::TestCase

  class A < String
    include Multiton
  end

  # B is also a multiton - with it's OWN object cache
  class B < A; end

  def test_multiple

    # w is the same object as x, y is the same object as z
    w,x,y,z = A.instance('A'), A.instance('A'), B.instance('B'), B.instance('B')

    yz_id = y.object_id || z.object_id

    B.class_eval {
      include Multiton
    }

    # y is not only the same object as z, but they are both the same object(s)
    # as from EXAMPLE C

    y,z = B.instance('B'), B.instance('B')

    assert_equal( y.object_id, yz_id )   # -> true
    assert_equal( z.object_id, yz_id ) # -> true

  end

end

#
# EXAMPLE E - SO YOU WANNA USE NEW INSTEAD OF INSTANCE...
#
class TC_Multiton_E < Test::Unit::TestCase

  module K
    # use an inner class which is itself a multiton
    class K < String; include Multiton; end

    # define a new which returns a mutltion using #instance...
    class << self
      def new(*args, &block)
        K.instance *args, &block
      end
    end
  end

  def test_new

    the = K.new '4'
    answer = K.new '2'

    assert_equal( "42", sprintf( "%s%s", the, answer ) )  #-> 42
    assert_equal( K::K, the.class )  #-> K::K

  end

end

#
# EXAMPLE F - using Klass.multiton_id
#
class TC_Multiton_F < Test::Unit::TestCase

  class Klass
    include Multiton

    def initialize( important, not_important )
      @important, @not_important = important, not_important
    end

    def Klass.multiton_id(*args, &block)
      # we consider only the first arg
      important, not_important = *args
      important
    end
  end

  def test_using_id
    a = Klass.instance( :a, :b )
    b = Klass.instance( :a, :c )
    c = Klass.instance( :b, :b )

    assert_equal( a, b )
    assert_not_equal( a, c )
    assert_not_equal( b, c )
  end

end
