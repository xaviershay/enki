unless (RUBY_VERSION[0,3] == '1.9')

  class Binding

    # Evaluate a Ruby source code string (or block) in the binding context.

    def eval(str) #='', &blk )
      #if block_given?
      #  Kernel.eval( self, &blk )
      #elsif str
        Kernel.eval(str, self)
      #end
    end

  end

end
