class Binding

  # Returns the nature of something within the context of the binding.
  # Returns nil if that thing is not defined.

  def defined?(x)
    eval("defined? #{x}")
  end

end
