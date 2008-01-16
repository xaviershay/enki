# Test for facets/time/stamp

require 'facets/time/stamp.rb'

require 'test/unit'
require 'time'

class TC_Time_Stamp < Test::Unit::TestCase

  def setup
    @t = Time.parse('4/20/2005 15:37')
  end

  # TODO Problem with TIMEZONE.

  #def test_stamp_01
  #  assert_equal( "Wed Apr 20 15:37:00 PDT 2005", @t.stamp )
  #end

  def test_stamp_02
    assert_equal( "April 20, 2005 15:37", @t.stamp(:long) )
  end

  def test_stamp_03
    assert_equal( "20 Apr 15:37", @t.stamp(:short) )
  end

end
