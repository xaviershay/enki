# TEst for facets/class/initializer.rb

require 'facets/class/initializer.rb'

require 'test/unit'

class TC_Class_Initializer < Test::Unit::TestCase

  def test_initializer
    cc = Class.new
    cc.class_eval {
      initializer :ai
      attr_reader :ai
    }
    c = cc.new(10)
    assert_equal( 10, c.ai )
  end

end
