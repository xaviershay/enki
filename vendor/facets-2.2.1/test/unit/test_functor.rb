# Test lib/facets/functor.rb

require 'facets/functor.rb'
require 'test/unit'

class TC_Functor < Test::Unit::TestCase

  def test_function
    f = Functor.new { |op, x| x.send(op, x) }
    assert_equal( 2, f + 1 ) #=> 2
    assert_equal( 4, f + 2 ) #=> 4
    assert_equal( 6, f + 3 ) #=> 6
    assert_equal( 1, f * 1 ) #=> 1
    assert_equal( 4, f * 2 ) #=> 4
    assert_equal( 9, f * 3 ) #=> 9
  end

  def test_decoration
    a = 'A'
    f = Functor.new{ |op, x| x.send(op, a + x) }
    assert_equal( 'BAB', f + 'B' )
    assert_equal( 'CAC', f + 'C' )
    assert_equal( 'DAD', f + 'D' )
  end

end
