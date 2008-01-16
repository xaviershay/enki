module Kernel

  # A Ruby-ized realization of the K combinator.
  #
  #   returning Book.new do |book|
  #     book.title = "Imperium"
  #     book.author = "Ulick Varange"
  #   end
  #
  # Also aliased as #with.
  #
  #   def foo
  #     with values = [] do
  #       values << 'bar'
  #       values << 'baz'
  #     end
  #   end
  #
  #   foo # => ['bar', 'baz']
  #
  # Technically, #returning probably should force the return of
  # the stated object irregardless of any return statements that
  # might appear within it's block. This might differentiate
  # #returning from #with, however it also would require
  # implementation in Ruby itself.
  #
  #   CREDIT: Mikael Brockman

  def returning(obj=self)
    yield obj
    obj
  end

  alias_method :with, :returning

  # Repeat loop until it yeilds false or nil.
  #
  #   a = [3, 2, 1]
  #   complete do
  #     b << a.pop
  #   end
  #   b  #=> [3, 2, 1, nil]
  #
  #  CREDIT: Trans

  def complete
    loop { break unless yield }
  end

end
