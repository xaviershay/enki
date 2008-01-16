# Test facets/timer.rb

require 'facets/timer.rb'

require 'test/unit'

class TC_Timer < Test::Unit::TestCase

  def test_timed
    timed { |timer|
      assert_equal 0, timer.total_time.round
      sleep 1
      assert_equal 1, timer.total_time.round
      timer.stop
      assert_equal 1, timer.total_time.round
      sleep 1
      assert_equal 1, timer.total_time.round
      timer.start
      assert_equal 1, timer.total_time.round
      sleep 1
      assert_equal 2, timer.total_time.round
    }
  end

  def test_outoftime
    t = Timer.new(1)
    assert_raises( TimeoutError ) {
      t.start
      sleep 2
      t.stop
    }
  end

  # This has been removed becuase it is too close to call.
  # Sometimes and error is returned sometimes it is not.
  #def test_nickoftime
  #  assert_raises( TimeoutError ) {
  #    @t.start
  #    sleep 2
  #    @t.stop
  #  }
  #end

  def test_intime
    t = Timer.new(2)
    assert_nothing_raised {
      t.start
      sleep 1
      t.stop
    }
  end

end



