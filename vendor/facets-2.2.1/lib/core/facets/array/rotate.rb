class Array

  # Rotates an array's elements from back to front n times.
  #
  #   [1,2,3].rotate      #=> [3,1,2]
  #   [3,1,2].rotate      #=> [2,3,1]
  #   [3,1,2].rotate      #=> [1,2,3]
  #   [1,2,3].rotate(3)   #=> [1,2,3]
  #
  # A negative parameter reverses the order from front to back.
  #
  #   [1,2,3].rotate(-1)  #=> [2,3,1]
  #
  #   CREDIT: Florian Gross
  #   CREDIT: Thomas Sawyer

  def rotate(n=1)
    self.dup.rotate!(n)
  end

  # Same as #rotate, but acts in place.
  #
  #   a = [1,2,3]
  #   a.rotate!
  #   a  #=> [3,1,2]
  #
  #   CREDIT: Florian Gross
  #   CREDIT: Thomas Sawyer

  def rotate!(n=1)
    n = n.to_int
    return self if (n == 0 or self.empty?)
    if n > 0
      n.abs.times{ self.unshift( self.pop ) }
    else
      n.abs.times{ self.push( self.shift ) }
    end
    self
  end

end
