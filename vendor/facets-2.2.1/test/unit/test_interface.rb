# Test facets/interface.rb

# get a hold of the original definition _before require_
$orginal_instance_methods = Module.instance_method( :instance_methods )

require 'facets/interface.rb'
require 'test/unit'


class TestModuleInterface < Test::Unit::TestCase

  # fixture

  class O
    def a ; end
  end

  def setup
    @o = O.new

    # get a hold of the original definition _before require_
    @om = @o.method( :methods )
  end

  # interface

  def test_interface
    assert_equal( @om.call.sort, @o.interface.sort )
  end

  def test_public_interface
    assert_equal( @o.public_methods.sort, @o.interface(:public).sort )
  end

  def test_private_interface
    assert_equal( @o.private_methods.sort, @o.interface(:private).sort )
  end

  def test_protected_interface
    assert_equal( @o.protected_methods.sort, @o.interface(:protected).sort )
  end

  def test_singleton_interface
    assert_equal( @o.singleton_methods.sort, @o.interface(:singleton).sort )
  end

  def test_local_interface
    assert_equal( ["a"], @o.interface(:local) )
  end

  # instance_interface

  def test_instance_interface
    m = $orginal_instance_methods #.dup
    assert_equal( m.bind(O).call.sort, O.instance_interface.sort )
  end

  def test_instance_interface_true
    m = $orginal_instance_methods #.dup
    assert_equal( m.bind(O).call(true).sort, O.instance_interface(true).sort )
  end

  def test_public_instance_interface
    assert_equal( O.public_instance_methods.sort, O.instance_interface.sort )
  end

  def test_private_instance_interface
    assert_equal( O.private_instance_methods.sort, O.instance_interface(:private).sort )
  end

  def test_protected_instance_interface
    assert_equal( O.protected_instance_methods.sort, O.instance_interface(:protected).sort )
  end

  def test_local_instance_interface
    assert_equal( ["a"], O.instance_interface(:local) )
  end

  def test_instance_interface_local_and_ancestors
    m = $orginal_instance_methods #.dup
    assert_equal( m.bind(O).call(true).sort, O.instance_interface(:local, :ancestors).sort )
  end

end
