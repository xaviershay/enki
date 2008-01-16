# Test facets/synchash.rb

require 'facets/synchash.rb'

require 'test/unit'

# TODO

class TC_SyncHash < Test::Unit::TestCase

  def test_01
    assert_nothing_raised{ @h = SyncHash.new }
  end

end



