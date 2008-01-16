class String

  # Escape string for Regexp use.
  #
  #   "H..LO".regesc  #=> "H\\.\\.LO"
  #
  #   CREDIT: Trans

  def regesc
    Regexp.escape(self)
  end

end


module Kernel

  # Provides a shortcut to the Regexp.escape module method.
  #
  #   resc("H..LO")   #=> "H\\.\\.LO"
  #
  #   TODO: Should this be deprecated in favor of String#regesc ?
  #
  #   CREDIT: Trans

  def resc(str)
    Regexp.escape(str)
  end

end
