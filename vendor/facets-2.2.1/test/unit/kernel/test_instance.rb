# Test for facets/kernel/instance

require 'facets/kernel/instance.rb'

require 'test/unit'

class TestKernelInstance < Test::Unit::TestCase

  def test_instance_class
    o = Object.new
    assert_equal( (class << o; self; end), o.instance_class )
  end

  def test_instance_assign
    ahash = { "z"=>0, "@a"=>1, "@b"=>2 } #, "@@a"=>3 }
    instance_assign( ahash )
    assert_equal( 0, @z )
    assert_equal( 1, @a )
    assert_equal( 2, @b )
    #assert_equal( 3, @@a )
  end

end

class TestInstanceEvalWithArgs < Test::Unit::TestCase

  class Dummy
    def f
      :dummy_value
    end
  end

  def test_instance_exec
    # Create a block that returns the value of an argument
    # and a value of a method call to +self+.
    block = lambda { |a| [a, f] }
    assert_equal [:arg_value, :dummy_value],
      Dummy.new.instance_exec(:arg_value, &block)
  end

  def test_instance_exec_with_frozen_obj
    block = lambda { |a| [a, f] }
    obj = Dummy.new
    obj.freeze
    assert_equal [:arg_value, :dummy_value], obj.instance_exec(:arg_value, &block)
  end

  def test_instance_exec_nested
    i = 0
    obj = Dummy.new
    block = lambda do |arg|
      [arg] + instance_exec(1){|a| [f, a] }
    end
    assert_equal([:arg_value, :dummy_value, 1], obj.instance_exec(:arg_value, &block))
  end

  def test_instance_exec_with_immediate_value
    obj = 1
    block = lambda { |a| [a,self] }
    assert_equal(["A", 1], obj.instance_exec("A", &block))
  end

end
