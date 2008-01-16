class Array

  # Returns the _only_ element in the array.  Raises an IndexError if
  # the array's size is not 1.
  #
  #   [5].only      # -> 5
  #   [1,2,3].only  # -> IndexError
  #   [].only       # -> IndexError
  #
  #   CREDIT: Gavin Sinclair
  #   CREDIT: Noah Gibbs

  def only
    unless size == 1
      raise IndexError, "Array#only called on non-single-element array"
    end
    first
  end
end

