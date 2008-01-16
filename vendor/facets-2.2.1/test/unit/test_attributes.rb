# Test facets/attributes.rb

require 'facets/attributes.rb'

require 'test/unit'

class TC_Attributes_Using_Attr < Test::Unit::TestCase
  class A
    attr :x, :cast=>"to_s"
  end

  def test_01
    assert_equal( "to_s", A.ann(:x,:cast) )
  end
end

class TC_Attributes_Using_Attr_Accessor < Test::Unit::TestCase
  class A
    attr_accessor :x, :cast=>"to_s"
  end

  def test_01
    a = A.new
    assert_equal( [:x], A.instance_attributes )
  end
end
