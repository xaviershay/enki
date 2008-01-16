# Test for facets/proc/bind

require 'facets/proc/bind.rb'

require 'test/unit'

class TestProc < Test::Unit::TestCase

  def test_to_method
    a = 2
    tproc = proc { |x| x + a }
    tmethod = tproc.to_method(:tryit)
    assert_equal( 3, tmethod.call(1) )
    assert_respond_to( self, :tryit )
    assert_equal( 3, tryit(1) )
  end

  # Not sure why this is thread critical?

  def test_memory_leak
    a = 2
    tproc = lambda { |x| x + a }
    99.times {
      tmethod = tproc.to_method
      assert_equal( 3, tmethod.call(1) )
    }
    meths = (
      Object.instance_methods +
      Object.public_instance_methods +
      Object.private_instance_methods +
      Object.protected_instance_methods
    )
    meths = meths.select{ |s| s.to_s =~ /^_bind_/ }
    #meths = Symbol.all_symbols.select { |s| s.to_s =~ /^_bind_/ }  # why?
    assert_equal( 0, meths.size )
  end

end
