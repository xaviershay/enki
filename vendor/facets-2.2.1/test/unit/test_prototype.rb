# Test facets/prototype.rb

require 'facets/prototype.rb'

require 'test/unit'

class TestPrototypeKernel < Test::Unit::TestCase

  def test_new
    q = nil
    s = "Testing"
    assert_nothing_raised { q = s.new }
    assert_equal( s, q )
    assert_not_equal( s.object_id, q.object_id )
  end
end

class TestPrototype < Test::Unit::TestCase

  def setup
    @person = prototype do
      @name = ''
      @age = 0
      @announce = fn { |x| "#{x}, #{name} is #{age}" }
    end

    @person.name = 'Tom'
    @person.age = 35
  end

  def test_simple_case
    assert_equal( "Peter, Tom is 35", @person.announce['Peter'])
  end

end
