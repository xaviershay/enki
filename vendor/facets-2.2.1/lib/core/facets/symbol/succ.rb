# DEPRECATE for 1.9
unless (RUBY_VERSION[0,3] == '1.9')

  class Symbol

    # Successor method for symobol. This simply converts
    # the symbol to a string uses String#succ and then
    # converts it back to a symbol.
    #
    #   :a.succ => :b
    #
    #   TODO: Make this  work more like a simple character dial.

    def succ
      self.to_s.succ.intern
    end
  end

end

