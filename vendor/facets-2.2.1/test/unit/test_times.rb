# Test facets/times.rb

require 'facets/times.rb'
require 'test/unit'
#require 'mega/multiplier'

class NumericTest < Test::Unit::TestCase

  #def test_micro_seconds
  #  assert_equal( 0.000001, 1.microsecond )
  #end

  #def test_milli_seconds
  #  assert_equal( 0.001, 1.millisecond )
  #end

  def test_seconds
    assert_equal( 60**0, 1.seconds )
  end

  def test_minutes
    assert_equal( 60**1, 1.minutes )
  end

  def test_hours
    assert_equal( 60**2, 1.hours )
  end

  def test_days
    assert_equal( 24*(60**2), 1.days )
  end

  def test_weeks
    assert_equal( 7*24*(60**2), 1.weeks )
  end

  def test_fortnights
    assert_equal( 14*24*(60**2), 1.fortnights )
  end

  def test_months
    assert_equal( 30*24*(60**2), 1.months )
  end

  def test_years
    assert_equal( 365*24*(60**2), 1.years )
  end

  def test_before
    t = Time.now
    assert_equal( t - 1.day, 1.day.before(t) )
  end

  def test_after
    t = Time.now
    assert_equal( t + 1.day, 1.day.after(t) )
  end

end

class WeekdaysTest < Test::Unit::TestCase

  MONDAY = Time.at(1165250000)
  THURSDAY = Time.at(1165500000)
  FRIDAY = Time.at(1165606025)

  def test_weekday_after_monday
    assert_equal 2, 1.weekday.since(MONDAY).wday
  end

  def test_weekday_after_friday
    assert_equal 1, 1.weekday.after(FRIDAY).wday
  end

  def test_weekdays_before_friday
    assert_equal 2, 3.weekdays.before(FRIDAY).wday
  end

  #def test_weekday_before_today
  #  Time.expects(:now).returns(THURSDAY)
  #  assert_equal 3, 1.weekday.ago.wday
  #end

  #def test_weekdays_after_today
  #  Time.expects(:now).returns(MONDAY)
  #  assert_equal 3, 2.weekday.from_now.wday
  #end

end
