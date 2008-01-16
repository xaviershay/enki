class Module

  private

  # Alias for remove_method.
  alias_method :remove, :remove_method

  # Alias for undef_method.
  alias_method :nodef, :undef_method

  public

  # Using integrate is just like using include except the
  # module included is a reconstruction of the one given
  # altered by the commands given in the block.
  #
  # Convenient commands available are: #rename, #redef,
  # #remove, #nodef and #wrap. But any module method
  # can be used.
  #
  #   module W
  #     def q ; "q" ; end
  #     def y ; "y" ; end
  #   end
  #
  #   class X
  #     integrate W do
  #       nodef :y
  #     end
  #   end
  #
  #   x = X.new
  #   x.q  #=> "q"
  #   x.y  #=> missing method error
  #
  # This is like #revisal, but #revisal only
  # returns the reconstructred module. It does not
  # include it.
  #
  #   CREDIT: Trans

  def integrate(mod, &block)
    #include mod.revisal( &blk )
    m = Module.new{ include mod }
    m.class_eval(&block)
    include m
  end

  # Return a new module based on another.
  # This includes the original module into the new one.
  #
  #   CREDIT: Trans

  def revisal(&blk)
    base = self
    nm = Module.new{ include base }
    nm.class_eval(&blk)
    nm
  end

  private

  # Creates a new method for a pre-existing method.
  #
  # If _aka_ is given, then the method being redefined will
  # first be aliased to this name.
  #
  #   class Greeter
  #     def hello ; "Hello" ; end
  #   end
  #
  #   Greeter.new.hello   #=> "Hello"
  #
  #   class Greeter
  #     redefine_method( :hello, :hi ) do
  #       hi + ", friend!"
  #     end
  #   end
  #
  #   Greeter.new.hello   #=> "Hello, friend!"
  #
  #   CREDIT: Trans

  def redefine_method(sym, aka=nil, &blk)
    raise ArgumentError, "method does not exist" unless method_defined?( sym )
    alias_method( aka, sym ) if aka
    undef_method( sym )
    define_method( sym, &blk )
  end

  alias_method :redef, :redefine_method

  # Redirect methods to other methods. This simply
  # defines methods by the name of a hash key which
  # calls the method with the name of the hash's value.
  #
  #   class Example
  #     redirect_method :hi => :hello, :hey => :hello
  #     def hello(name)
  #       puts "Hello, #{name}."
  #     end
  #   end
  #
  #   e = Example.new
  #   e.hello("Bob")    #=> "Hello, Bob."
  #   e.hi("Bob")       #=> "Hello, Bob."
  #   e.hey("Bob")      #=> "Hello, Bob."
  #
  # The above class definition is equivalent to:
  #
  #   class Example
  #     def hi(*args)
  #       hello(*args)
  #     end
  #     def hey(*args)
  #       hello(*args)
  #     end
  #     def hello
  #       puts "Hello"
  #     end
  #   end
  #
  #   CREDIT: Trans

  def redirect_method( method_hash )
    method_hash.each do |targ,adv|
      define_method(targ) { |*args| send(adv,*args) }
    end
  end

  alias_method :redirect, :redirect_method

  # Aliases a method and undefines the original.
  #
  #   rename_method( :to_method, :from_method  )
  #
  #   CREDIT: Trans

  def rename_method( to_sym, from_sym )
    raise ArgumentError, "method #{from_sym} does not exist" unless method_defined?( from_sym )
    alias_method( to_sym, from_sym )
    undef_method( from_sym )
  end

  alias_method :rename, :rename_method

  # Don't think we should bother making this private.
  # That sort of defeats some of the AOP usefulness of this.
  public #private

  # Creates a new method wrapping the previous of
  # the same name. Reference to the old method
  # is passed into the new definition block
  # as the first parameter.
  #
  #   wrap_method( sym ) { |old_meth, *args|
  #     old_meth.call
  #     ...
  #   }
  #
  # Keep in mind that this can not be used to wrap methods
  # that take a block.
  #
  #   CREDIT: Trans

  def wrap_method( sym, &blk )
    old = instance_method(sym)
    define_method(sym) { |*args| blk.call(old.bind(self), *args) }
  end

  alias_method :wrap, :wrap_method

end
