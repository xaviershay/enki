# Test lib/facets/snapshot.rb

require 'facets/snapshot.rb'

require 'test/unit'

class TC_Snapshot < Test::Unit::TestCase

  def setup
    customer = Struct.new(:name, :address, :zip)
    joe = customer.new( "Joe Pitare", "1115 Lila Ln.", 47634 )
    @joe_snap = joe.take_snapshot
  end

  def test_storage
    assert_equal( "Joe Pitare", @joe_snap[:name]  )
    assert_equal( "1115 Lila Ln.", @joe_snap[:address] )
    assert_equal( 47634, @joe_snap[:zip] )
  end

end



