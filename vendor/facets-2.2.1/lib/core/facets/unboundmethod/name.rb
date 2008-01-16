# DEPRECATE for 1.9
unless (RUBY_VERSION[0,3] == '1.9')

  class UnboundMethod

    # Return the name of the method.
    # Is this already in 1.9+ ?
    #
    #   class X
    #     def foo; end
    #   end
    #
    #   meth = X.instance_method(:foo)
    #
    #   meth.name  #=> "foo"
    #
    #   CREDIT: Trans

    def name
      i = to_s.rindex('#')
      to_s.slice(i+1...-1)
    end

  end

end
