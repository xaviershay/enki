# Test for facets/time/elapse

require 'facets/time/elapse.rb'

require 'test/unit'
#require 'time'

class TestTime < Test::Unit::TestCase

  def test_elapse
    #t = Time.parse('4/20/2006 15:37')
    t = Time.elapse { sleep 1 }
    assert( (t > 0.9) && (t < 2.1 ))
  end

end
