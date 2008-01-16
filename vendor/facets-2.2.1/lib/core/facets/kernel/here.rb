module Kernel
  # A shorthand pronoun for binding().
  #
  #   a = 3
  #   b = here
  #   eval( "a", b )  #=> 3
  #
  alias_method :here, :binding
end
