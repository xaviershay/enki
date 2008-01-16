# Test for facets/exception/detail

require 'facets/exception/detail'
require 'test/unit'

class TC_Exception < Test::Unit::TestCase

  def test_detail
    begin
      raise ArgumentError
    rescue ArgumentError => err
      e = 
      r = err.detail
      assert_equal(e,r)
    end
  end

end

