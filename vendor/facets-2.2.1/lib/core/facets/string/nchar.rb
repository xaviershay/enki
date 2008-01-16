class String

  # Does a string start with the given prefix.
  #
  #   "hello".starts_with?("he")    #=> true
  #   "hello".starts_with?("to")    #=> false
  #
  #   CREDIT: Lucas Carlson
  #   CREDIT: Blaine Cook

  def starts_with?(prefix)
    self.index(prefix) == 0
  end

  # Does a string end with the given suffix?
  #
  #   "hello".ends_with?("lo")    #=> true
  #   "hello".ends_with?("to")    #=> false
  #
  #   CREDIT: Lucas Carlson
  #   CREDIT: Blaine Cook

  def ends_with?(suffix)
    self.rindex(suffix) == size - suffix.size
  end

  # Retrns _n_ characters of the string. If _n_ is positive
  # the characters are from the beginning of the string.
  # If _n_ is negative from the end of the string.
  #
  # Alternatively a replacement string can be given, which will
  # replace the _n_ characters.
  #
  #    str = "this is text"
  #    str.nchar(4)            #=> "this"
  #    str.nchar(4, 'that')    #=> "that"
  #    str                     #=> "that is text"
  #
  #   CREDIT: ?

  def nchar(n, replacement=nil)
    if replacement
      s = self.dup
      n > 0 ? (s[0...n] = replacement) : (s[n..-1] = replacement)
      return s
    else
      n > 0 ? self[0...n] : self[n..-1]
    end
  end

  # Left chomp.
  #
  #   "help".lchomp("h")  #=> "elp"
  #   "help".lchomp("k")  #=> "help"
  #
  #   CREDIT: Trans

  def lchomp(match)
    if index(match) == 0
      self[match.size..-1]
    else
      self.dup
    end
  end

  # In-place left chomp.
  #
  #   "help".lchomp("h")  #=> "elp"
  #   "help".lchomp("k")  #=> "help"
  #
  #   CREDIT: Trans

  def lchomp!(match)
    if index(match) == 0
      self[0...match.size] = ''
      self
    end
  end

end
