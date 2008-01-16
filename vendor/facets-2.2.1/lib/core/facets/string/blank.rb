class String

  # Is this string just whitespace?
  #
  #   "abc".blank?  #=> false
  #   "   ".blank?  #=> true
  #
  #   CREDIT: ?

  def blank?
    self !~ /\S/
  end

  alias whitespace? blank?

end
