module Kernel

  unless (RUBY_VERSION[0,3] == '1.9')


  end

  alias_method :pp_call_stack, :caller

  # Parse a caller string and break it into its components,
  # returning an array. Returns:
  # * file (String)
  # * lineno (Integer)
  # * method (Symbol)
  #
  # For example, from irb,
  #
  #   call_stack(1)
  #
  # _produces_
  #
  # [["(irb)", 2, :irb_binding],
  #  ["/usr/lib/ruby/1.8/irb/workspace.rb", 52, :irb_binding],
  #  ["/usr/lib/ruby/1.8/irb/workspace.rb", 52, nil]]
  #
  # Note: If the user decides to redefine caller() to output data
  # in a different format, _prior_ to requiring this, then the
  # results will be indeterminate.
  #
  #   CREDIT: Trans

  def call_stack( level = 1 )
    call_str_array = pp_call_stack(level)
    stack = []
    call_str_array.each{ |call_str|
      file, lineno, method = call_str.split(':')
      if method =~ /in `(.*)'/ then
        method = $1.intern()
      end
      stack << [file, lineno.to_i, method]
    }
    stack
  end

  private


  if (RUBY_VERSION[0,3] == '1.9')

    alias_method :callee, :__callee__
    alias_method :called, :__callee__

  else

    # Retreive the current running method name.
    # There is a lot of debate on what to call this.
    # #called differs from #method_name only by the fact
    # that it returns a symbol, rather then a string.
    #
    #   def tester; called; end
    #   tester  #=> :tester
    #
    def called
      /\`([^\']+)\'/.match(caller(1).first)[1].to_sym
    end

    # Retreive the current running method name.
    #
    # There is a lot of debate on what to call this.
    # #me returns a symbol, not a string.
    #
    #   def tester; __method__; end
    #   tester  #=> :tester
    #
    def callee
      /\`([^\']+)\'/.match(caller(1).first)[1].to_sym
    end

    # Technically __callee__ should provided alias names,
    # where __method__ should not. But we'll have to
    # leave that distinction to Ruby 1.9+.

    alias_method :__callee__, :called
    alias_method :__method__, :called

  end

end
