class Module

  # Like attr_writer, but the writer method validates the
  # setting against the given block.
  #
  #   CREDIT: ?

  def attr_validator(*symbols, &validator)
    made = []
    symbols.each do |symbol|
      define_method "#{symbol}=" do |val|
        unless validator.call(val)
          raise ArgumentError, "Invalid value provided for #{symbol}"
        end
        instance_variable_set("@#{symbol}", val)
      end
      made << "#{symbol}=".to_sym
    end
    made
  end

  # Create aliases for validators.

  def alias_validator(*args)
    orig = args.last
    args = args - [orig]
    args.each do |name|
      #alias_method(name, orig)
      alias_method("#{name}=", "#{orig}=")
    end
  end

  # TODO Perhaps need to make a check against overriding annotated version.

  # Create an attribute method for both getting
  # and setting an instance variable.
  #
  #   attr_setter :a
  #
  # _is equivalent to_
  #
  #   def a(*args)
  #     if args.size > 0
  #       @a = args[0]
  #       self
  #     else
  #       @a
  #     end
  #   end
  #
  #  CREDIT: Trans

  def attr_setter(*args)
    code, made = '', []
    args.each do |a|
      code << %{
        def #{a}(*args)
          args.size > 0 ? ( @#{a}=args[0] ; self ) : @#{a}
        end
      }
      made << "#{a}".to_sym
    end
    module_eval code
    made
  end

  # Alias an accessor. This create an alias for
  # both a reader and a writer.
  #
  #   class X
  #     attr_accessor :a
  #     alias_accessor :b, :a
  #   end
  #
  #   x = X.new
  #   x.b = 1
  #   x.a        #=> 1
  #
  #  CREDIT: Trans

  def alias_setter(*args)
    args = args - [orig]
    args.each do |name|
      alias_method(name, orig)
    end
  end

  # Create a toggle attribute. This creates two methods for
  # each given name. One is a form of tester and the other
  # is used to toggle the value.
  #
  #   attr_accessor! :a
  #
  # is equivalent to
  #
  #   def a?
  #     @a
  #   end
  #
  #   def a!(value=true)
  #     @a = value
  #     self
  #   end
  #
  #  CREDIT: Trans

  def attr_accessor!(*args)
    attr_reader!(*args) + attr_writer!(*args)
  end
  alias_method :attr_switcher, :attr_accessor!
  alias_method :attr_toggler,  :attr_accessor!

  # Create aliases for flag accessors.
  #
  #  CREDIT: Trans

  def alias_accessor!(*args)
    orig = args.last
    args = args - [orig]
    args.each do |name|
      alias_method("#{name}?", "#{orig}?")
      alias_method("#{name}!", "#{orig}!")
    end
  end
  alias_method :alias_switcher, :alias_accessor!
  alias_method :alias_toggler,  :alias_accessor!

  # Create an tester attribute. This creates a single method
  # used to test the attribute for truth.
  #
  #   attr_reader! :a
  #
  # is equivalent to
  #
  #   def a?
  #     @a ? true : @a
  #   end

  def attr_reader!(*args)
    code, made = '', []
    args.each do |a|
      code << %{
        def #{a}?(truth=nil)
          @#{a} ? truth || @#{a} : @#{a}
        end
      }
      made << "#{a}?".to_sym
    end
    module_eval code
    made
  end
  alias_method :attr_reader?, :attr_reader!
  alias_method :attr_tester, :attr_reader!

  # Create aliases for flag reader.
  #
  #  CREDIT: Trans

  def alias_reader!(*args)
    orig = args.last
    args = args - [orig]
    args.each do |name|
      alias_method("#{name}?", "#{orig}?")
    end
  end
  alias_method :alias_reader?, :alias_reader!
  alias_method :alias_tester, :alias_reader!

  # Create a flaggable attribute. This creates a single methods
  # used to set an attribute to "true".
  #
  #   attr_writer! :a
  #
  # is equivalent to
  #
  #   def a!(value=true)
  #     @a = value
  #     self
  #   end

  def attr_writer!(*args)
    code, made = '', []
    args.each do |a|
      code << %{
        def #{a}!(value=true)
          @#{a} = value
          self
        end
      }
      made << "#{a}!".to_sym
    end
    module_eval code
    made
  end

  # Create aliases for flag writer.
  #
  #  CREDIT: Trans

  def alias_writer!(*args)
    orig = args.last
    args = args - [orig]
    args.each do |name|
      alias_method("#{name}!", "#{orig}!")
    end
  end

end
