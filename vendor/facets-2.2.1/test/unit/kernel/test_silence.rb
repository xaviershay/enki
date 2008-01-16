# Test for facets/kernel/silence

require 'facets/kernel/silence.rb'

require 'test/unit'

class TestKernelError < Test::Unit::TestCase

  def test_silence_warnings
    silence_warnings do
      assert( ! $VERBOSE )
    end
  end

end
