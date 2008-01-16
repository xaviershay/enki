# Test facets/let.rb

require 'facets/let.rb'
require 'test/unit'

class TCthis < Test::Unit::TestCase

  class Foo
    let.bar = 10
  end

  def test01
    x = Foo.new
    assert_equal( 10, x.bar )
  end

end


