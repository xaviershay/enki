# DEPRECATE for 1.9
unless (RUBY_VERSION[0,3] == '1.9')

  class Symbol

    # Turn a symbol into a proc calling the method to
    # which it refers.
    #
    #   up = :upcase.to_proc
    #   up.call("hello")  #=> HELLO
    #
    # More useful is the fact that this allows <tt>&</tt>
    # to be used to coerce Symbol into Proc.
    #
    #   %w{foo bar qux}.map(&:upcase)   #=> ["FOO","BAR","QUX"]
    #   [1, 2, 3].inject(&:+)           #=> 6
    #
    # And other conveniences such as:
    #
    #   %{john terry fiona}.map(&:capitalize)   # -> %{John Terry Fiona}
    #   sum = numbers.inject(&:+)
    #
    #   TODO: This will be deprecated as of Ruby 1.9, since it will become standard Ruby.
    #
    #   CREDIT: Florian Gross (orignal)
    #   CREDIT: Nobuhiro Imai (current)

    def to_proc
      Proc.new{|*args| args.shift.__send__(self, *args)}
    end

    # OLD DEFINITION
    #def to_proc
    #  proc { |obj, *args| obj.send(self, *args) }
    #end
  end

end

