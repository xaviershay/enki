# Test lib/facets/uninheritable.rb

require 'facets/uninheritable.rb'

require 'test/unit'

class TC_Uninheritable < Test::Unit::TestCase

  class Cannot
    extend Uninheritable
  end

  class Can
  end

  def test_module
    assert_nothing_raised {
      self.instance_eval <<-EOS
        class A < Can; end
      EOS
    }
    assert_raises(TypeError, "Class Cannot cannot be subclassed.") do
      self.instance_eval <<-EOS
        class B < Cannot; end
      EOS
    end
  end

end



