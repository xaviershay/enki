module Enumerable

  # As with each_combo but returns combos collected in an array.
  #
  #   CREDIT: Trans

  def combos
    a = []
    each_combo{ |c| a << c }
    a
  end

  # Expected to be an enumeration of arrays. This method
  # iterates through combinations of each in position.
  #
  #   a = [ [0,1], [2,3] ]
  #   a.each_combo { |c| p c }
  #
  # produces
  #
  #   [0, 2]
  #   [0, 3]
  #   [1, 2]
  #   [1, 3]
  #
  #   CREDIT: Trans

  def each_combo
    a = collect{ |x|
      x.respond_to?(:to_a) ? x.to_a : 0..x
    }

    if a.size == 1
      r = a.shift
      r.each{ |n|
        yield n
      }
    else
      r = a.shift
      r.each{ |n|
        a.each_combo{ |s|
          yield [n, *s]
        }
      }
    end
  end

end
