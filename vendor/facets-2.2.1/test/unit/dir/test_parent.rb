# Test for facets/dir/parent.rb.

require 'facets/dir/parent'
require 'test/unit'


class TC_Dir < Test::Unit::TestCase

  def test_parent
    assert( Dir.parent?( "a/b/c", "a/b/c/d" ) )
  end

end

