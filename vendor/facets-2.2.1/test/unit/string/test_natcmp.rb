# Test for facets/string/natcmp

require 'facets/string/natcmp.rb'

require 'test/unit'

class TestStringCompare < Test::Unit::TestCase

  def test_natcmp
    assert( -1, "my_prog_v1.1.0".natcmp("my_prog_v1.2.0") )
    assert( -1, "my_prog_v1.2.0".natcmp("my_prog_v1.10.0") )
    assert( 1, "my_prog_v1.2.0".natcmp("my_prog_v1.1.0") )
    assert( 1, "my_prog_v1.10.0".natcmp("my_prog_v1.2.0") )
    assert( 0, "my_prog_v1.0.0".natcmp("my_prog_v1.0.0") )
  end

end
