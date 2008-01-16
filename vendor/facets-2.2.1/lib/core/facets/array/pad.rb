# = Array Padding Extensions
#
# Padding extensions for Array.

#
class Array

  # Pad an array with a given <tt>value</tt> upto a given <tt>length</tt>.
  #
  #   [0,1,2].pad(6,"a")  #=> [0,1,2,"a","a","a"]
  #
  # If <tt>length</tt> is a negative number padding will be added
  # to the beginning of the array.
  #
  #   [0,1,2].pad(-6,"a")  #=> ["a","a","a",0,1,2]
  #
  #   CREDIT: Richard Laugesen

  def pad(len, val=nil)
    return dup if self.size >= len.abs
    if len < 0
      Array.new((len+size).abs,val) + self
    else
      self + Array.new(len-size,val)
    end
  end

  # Like #pad but changes the array in place.
  #
  #    a = [0,1,2]
  #    a.pad!(6,"x")
  #    a  #=> [0,1,2,"x","x","x"]
  #
  #   CREDIT: Richard Laugesen

  def pad!(len, val=nil)
    return self if self.size >= len.abs
    if len < 0
      replace Array.new((len+size).abs,val) + self
    else
      concat Array.new(len-size,val)
    end
  end

end
