# Test facets/syncarray.rb

require 'facets/syncarray.rb'
require 'test/unit'

# TODO

class TC_SyncArray < Test::Unit::TestCase

  def test_01
    assert_nothing_raised{ @s = SyncArray.new }
  end

end



