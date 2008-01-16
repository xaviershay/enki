class String

  # Return true if the string is capitalized, otherwise false.
  #
  #   "THIS".capitalized?  #=> true
  #   "This".capitalized?  #=> true
  #   "this".capitalized?  #=> false
  #
  #   CREDIT: Phil Tomson

  def capitalized?
    self =~ /^[A-Z]/
  end

  # Return true if the string is lowercase (downcase), otherwise false.
  #
  #   "THIS".downcase?  #=> false
  #   "This".downcase?  #=> false
  #   "this".downcase?  #=> true
  #
  #   CREDIT: Phil Tomson

  def downcase?
    downcase == self
  end

  # Alias for #downcase? method.
  alias_method :lowercase?, :downcase?

  # Is the string upcase/uppercase?
  #
  #   "THIS".upcase?  #=> true
  #   "This".upcase?  #=> false
  #   "this".upcase?  #=> false
  #
  #   CREDIT: Phil Tomson

  def upcase?
    self.upcase == self
  end

  # Alias for #upcase? method.
  alias_method :uppercase?, :upcase?

  # Title case.
  #
  #   "this is a string".titlecase
  #   => "This Is A String"
  #
  #   CREDIT: Eliazar Parra

  def titlecase
    gsub(/\b\w/){$&.upcase}
  end

  # Converts a string to camelcase. By default capitalization
  # occurs on whitespace and underscores. By setting the first
  # parameter to <tt>true</tt> the first character can also be
  # captizlized. The second parameter can be assigned a valid
  # Regualr Expression characeter set to determine which
  # characters to match for capitalizing subsequent parts of
  # the string.
  #
  #   "this_is a test".camelcase             #=> "thisIsATest"
  #   "this_is a test".camelcase(true)       #=> "ThisIsATest"
  #   "this_is a test".camelcase(true, ' ')  #=> "This_isATest"
  #
  #   CREDIT: Trans

  def camelcase(first=false, on='_\s')
    if first
      gsub(/(^|[#{on}]+)([A-Za-z])/){ $2.upcase }
    else
      gsub(/([#{on}]+)([A-Za-z])/){ $2.upcase }
    end
  end

  # Snakecase (underscore) string based on camelcase characteristics.

  def snakecase #(camel_cased_word)
    gsub(/([A-Z]+)([A-Z])/,'\1_\2').gsub(/([a-z])([A-Z])/,'\1_\2').downcase
  end

end
