module Kernel

  # Like #respond_to? but returns the result of the call
  # if it does indeed respond.
  #
  #   class X
  #     def f; "f"; end
  #   end
  #
  #   x = X.new
  #   x.respond(:f)  #=> "f"
  #   x.respond(:g)  #=> nil
  #
  #   CREDIT: Trans

  def respond(sym, *args)
    return nil if not respond_to?(sym, *args)
    send(sym, *args)
  end

  alias_method :respond_with_value, :respond

end
