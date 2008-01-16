# DEPRECATE for 1.9.
unless (RUBY_VERSION[0,3] == '1.9')

  module Kernel

    # The tap K-Combinator. This yields self -and- returns self.
    #
    #   CREDIT: ?

    def tap(&b)
      if block_given?
        b.arity == 1 ? yield(self) : instance_eval(&b)
      end
      self
    end

    # This is just an odd consideration for #tap using Functor:
    #
    #   require 'facets/functor'
    #
    #   # Yield self -and- return self.
    #
    #   def tap(&b)
    #     if block_given?
    #       b.arity == 1 ? yield(self) : instance_eval(&b)
    #       self
    #     else
    #       Functor.new{ |op, *args| self.send(op, *args); self }
    #     end
    #   end

  end

end