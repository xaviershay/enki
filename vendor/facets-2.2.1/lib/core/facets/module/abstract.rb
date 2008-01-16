class Module

  # Create an abstract method. If it is not overridden, it will
  # raise a TypeError when called.
  #
  #   class C
  #     abstract :a
  #   end
  #
  #   c = C.new
  #   c.a  #=> Error: undefined abstraction #a
  #
  #   CREDIT: Trans

  def abstract( *sym )
    sym.each { |s|
      define_method( s ) { raise TypeError, "undefined abstraction ##{s}" }
    }
  end

end
