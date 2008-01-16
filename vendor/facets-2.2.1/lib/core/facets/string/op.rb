class String

  # Removes occurances of a string or regexp.
  #
  #   "HELLO HELLO" - "LL"    #=> "HEO HEO"
  #
  #   CREDIT: Benjamin David Oakes

  def -(pattern)
    self.gsub(pattern, '')
  end

end
