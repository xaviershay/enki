# Test facets/recorder.rb

require 'facets/recorder.rb'

require 'test/unit'

#class Object
#  def &(o)
#    self && o
#  end
#end

class TCRecorder < Test::Unit::TestCase

  class Z
    def name ; 'George' ; end
    def age ; 12 ; end
  end

  def setup
    @z = Z.new
  end

  def test_001
    r = Recorder.new
    q = proc { |x| (x.name == 'George') & (x.age > 10) }
    x = q[r]
    assert( x.__call__(@z) )
  end

end
