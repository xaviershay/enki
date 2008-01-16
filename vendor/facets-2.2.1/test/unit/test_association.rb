# Test facets/association.rb

require 'facets/association.rb'

require 'test/unit'

class TC_Associations < Test::Unit::TestCase

  def setup
    @complex_hierarchy = [
      'parent' >> 'child',
      'childless',
      'another_parent' >> [
        'subchildless',
        'subparent' >> 'subchild'
      ]
    ]
  end

  def test_ohash
    k,v = [],[]
    ohash = [ 'A' >> '3', 'B' >> '2', 'C' >> '1' ]
    ohash.each { |e1,e2| k << e1 ; v << e2 }
    assert_equal( ['A','B','C'], k )
    assert_equal( ['3','2','1'], v )
  end

  def test_complex
    complex = [ 'Drop Menu' >> [ 'Button 1', 'Button 2', 'Button 3' ], 'Help' ]
    assert_equal( 'Drop Menu', complex[0].index )
  end

  def test_associations
    complex = [ :a >> :b, :a >> :c ]
    assert_equal( [ :b, :c ], :a.associations )
  end

end
