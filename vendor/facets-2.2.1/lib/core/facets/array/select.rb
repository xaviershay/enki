class Array

  # As with #select but modifies the Array in place.
  #
  #   a = [1,2,3,4,5,6,7,8,9,10]
  #   a.select!{ |e| e % 2 == 0 }
  #   a  #=> [2,4,6,8,10]
  #
  #   CREDIT: Gavin Sinclair

  def select!  # :yield:
    reject!{ |e| not yield(e) }
  end

end
