# Test for facets/kernel/returning.rb

require 'facets/kernel/returning.rb'
require 'test/unit'

class TC_Kernel < Test::Unit::TestCase

  def test_returning
    foo = returning( values = [] ) do
      values << 'bar'
      values << 'baz'
    end
    assert_equal( ['bar', 'baz'], foo )
  end

end
