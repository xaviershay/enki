# Test for facets/kernel/populate

require 'facets/kernel/populate.rb'

require 'test/unit'

class TestKernelPopulate < Test::Unit::TestCase

  Customer = Struct.new( "Customer", :name, :address, :zip )

  #     def test_assign_from
  #       o = Object.new
  #       o.instance_eval{ @z=0; @a=1; @b=2 } #; @@a=3 }
  #       assign_from( o, "z", "@a", "@b" ) #, "@@a" )
  #       assert_equal( 1, @a )
  #       assert_equal( 2, @b )
  #       #assert_equal( 3, @@a )
  #     end

  def test_set_from
    bob = Customer.new("Bob Sawyer", "123 Maple, Anytown NC", 12345)
    joe = Customer.new("Joe Pitare")
    joe.set_from(bob, :address, :zip)
    assert_equal("Joe Pitare", joe.name)
    assert_equal("123 Maple, Anytown NC", joe.address)
    assert_equal(12345, joe.zip)
  end

  #Customer = Struct.new( "Customer", :name, :address, :zip )

  def test_hash
    bob = Customer.new()
    x = { :name => "Bob Sawyer", :address => "123 Maple, Anytown NC", :zip => 12345 }
    bob.set_with(x)
    assert_equal(x[:name], bob.name)
    assert_equal(x[:address], bob.address)
    assert_equal(x[:zip], bob.zip)
  end

  def test_block
    bob = Customer.new()
    x = lambda {|s| s.name = "Bob Sawyer"; s.address = "123 Maple, Anytown NC"; s.zip = 12345 }
    bob.set_with(&x)
    assert_equal("Bob Sawyer", bob.name)
    assert_equal("123 Maple, Anytown NC", bob.address)
    assert_equal(12345, bob.zip)
  end

end
