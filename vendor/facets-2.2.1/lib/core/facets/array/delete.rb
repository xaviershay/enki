class Array

  # Inverse of #delete_if.
  #
  #   [1,2,3].delete_unless{ |x| x < 2 }
  #   => [1,2]
  #
  #   CREDIT: Daniel Schierbeck

  def delete_unless(&block)
    delete_if { |element| not block.call(element) }
  end

  # Delete multiple values from array.
  #
  #   a = [1,2,3,4]
  #   a.delete_values(1,2)   #=> [1,2]
  #   a                      #=> [3,4]
  #
  #   CREDIT: Trans

  def delete_values(*values)
    d = []
    values.each{ |v| d << delete(v) }
    d
  end

  # Delete multiple values from array given
  # indexes or index range.
  #
  #   a = [1,2,3,4]
  #   a.delete_values_at(1,2)   #=> [2,3]
  #   a                         #=> [1,4]
  #   a = [1,2,3,4]
  #   a.delete_values_at(0..2)  #=> [1,2,3]
  #   a                         #=> [4]
  #
  #   CREDIT: Trans

  def delete_values_at(*selectors)
    idx = []
    selectors.each{ |i|
      case i
      when Range
        idx.concat( i.to_a )
      else
        idx << i.to_i
      end
    }
    idx.uniq!
    dvals = values_at(*idx)
    idx = (0...size).to_a - idx
    self.replace( values_at(*idx) )
    return dvals
  end

end
