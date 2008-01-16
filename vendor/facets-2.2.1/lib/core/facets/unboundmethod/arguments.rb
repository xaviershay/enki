class UnboundMethod

  # Resolves the arguments of the method to have an
  # identical signiture --useful for preserving arity.
  #
  #   class X
  #     def foo(a, b); end
  #     def bar(a, b=1); end
  #   end
  #
  #   foo_method = X.instance_method(:foo)
  #   foo_method.arguments   #=> "a0, a1"
  #
  #   bar_method = X.instance_method(:bar)
  #   bar_method.arguments   #=> "a0, *args"
  #
  # When defaults are used the arguments must end in "*args".
  #
  #   CREDIT: Trans

  def arguments
    ar = arity
    case ar <=> 0
    when 1
      args = []
      ar.times do |i|
        args << "a#{i}"
      end
      args = args.join(", ")
    when 0
      args = ""
    else
      ar = -ar - 1
      args = []
      ar.times do |i|
        args << "a#{i}"
      end
      args << "*args"
      args = args.join(", ")
    end
    return args
  end

end
