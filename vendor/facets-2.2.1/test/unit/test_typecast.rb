# Test facets/typecast.rb

require 'facets/typecast.rb'

require 'test/unit'

class TC_TypeCast < Test::Unit::TestCase

  class TestClass
    attr_accessor :my_var
    def initialize(my_var); @my_var = my_var; end

    def to_string(options={})
      @my_var
    end

    class << self
      def from_string(string, options={})
        self.new( string )
      end
    end
  end


  def setup
    @test_string = "this is a test"
    @test_class = TestClass.new(@test_string)
  end

  def test_to_string
    assert_equal( '1234', 1234.cast_to(String) )
  end

  def test_custom_to_string
    assert_equal( @test_string, @test_class.cast_to(String) )
  end

  def test_custom_from_string
    assert_equal( @test_class.my_var, @test_string.cast_to(TestClass).my_var )
  end

  def test_string_to_class
    assert_equal( Test::Unit::TestCase, "Test::Unit::TestCase".cast_to(Class) )
  end

  def test_string_to_time
    assert_equal( "Mon Oct 10 00:00:00 2005", "2005-10-10".cast_to(Time).strftime("%a %b %d %H:%M:%S %Y") )
  end

  def test_no_converter
    "sfddsf".cast_to( ::Regexp )
    assert(1+1==3, 'should not get here')
  rescue TypeCastException => ex
    assert_equal(TypeCastException, ex.class)
  end
end



