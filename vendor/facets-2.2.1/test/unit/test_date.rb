# Test facets/date.rb

require 'facets/date.rb'
require 'test/unit'

class TC_Date < Test::Unit::TestCase

  def setup
    @d = Date.civil( 2005, 04, 20 )
  end

  def test_to_date
    assert_instance_of( ::Date, @d.to_date )
  end

  def test_to_time
    assert_instance_of( ::Time, @d.to_time )
  end

  def test_to_s
    assert_equal( "2005-04-20", @d.to_s )
  end


  def test_stamp_1
    assert_equal( "2005-04-20", @d.stamp )
  end

  def test_stamp_2
    assert_equal( "20 Apr", @d.stamp(:short) )
  end

  def test_stamp_3
    assert_equal( "April 20, 2005", @d.stamp(:long) )
  end

  def test_days_in_month
    assert_equal( 31, Date.new(2004,1,1).days_in_month )
  end

  def test_days_of_month
    assert_equal( (1..@d.days_in_month).to_a, @d.days_of_month )
  end

end
