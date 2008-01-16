unless (RUBY_VERSION[0,3] == '1.9')
  require 'facets/proc/bind'
end

module Kernel
  #
  # Kernel extension prefixed by instance_ which provide
  # internal (eg private) access to the object.
  #

  unless (RUBY_VERSION[0,3] == '1.9')
    # Like instance_eval but allows parameters to be passed.
    #
    #   TODO: Remove for Ruby 1.9.

    def instance_exec(*arguments, &block)
      block.bind(self)[*arguments]
    end
  end

  # Shadow method for instance_variable_get.
  alias_method :__get__, :instance_variable_get

  # Shadow method for instance_variable_set.
  alias_method :__set__, :instance_variable_set

  # Private send. Why isn't #send called instance_send in the first place?
  alias_method :instance_send, :send

  # Easy access to an object qua class, otherwise known
  # as the object's metaclass or singleton class. This
  # implemnetation alwasy returns the class, even if a
  # block is provided to eval against it.
  #
  #     It is what it is.
  #
  #  CREDIT: Trans

  def instance_class( &block )
    (class << self; self; end).module_eval(&block) if block
    (class << self; self; end)
  end

  # Return instance variable values in an array.
  #
  #   class X
  #     def initialize(a,b)
  #       @a, @b = a, b
  #     end
  #   end
  #
  #   x = X.new(1,2)
  #
  #   x.instance_values   #=> [1,2]
  #
  #   CREDIT: David Heinemeier Hansson

  def instance_values
    instance_variables.inject({}) do |values, name|
    values[name[1..-1]] = instance_variable_get(name)
      values
    end
  end

  # Assign instance vars using another object.
  #
  #   class O
  #     attr_accessor :d
  #     def initialize( a, b, c, d)
  #       @a = a
  #       @b = b
  #       @c = c
  #       @d = d
  #     end
  #   end
  #   o1 = O.new(1,2,3,4)
  #   o2 = O.new(0,0,0,0)
  #
  #   o2.instance_assume( o1, '@a', '@b', '@c', '@d' )
  #   o2.instance_eval{ @a }  #=> 1
  #   o2.instance_eval{ @b }  #=> 2
  #   o2.instance_eval{ @c }  #=> 3
  #   o2.instance_eval{ @d }  #=> 4
  #
  #   CREDIT: Trans

  def instance_assume(obj, *vars)
    if vars.empty?
      vars = instance_vars | obj.instance_variables
    else
      vars = vars.collect do |k|
        var.to_s.slice(0,1) == '@' ? var : "@#{var}"
      end
      vars = vars | instance_variables | obj.instance_variables
    end
    vars.each do |var|
      instance_variable_set(var, obj.instance_variable_get(var))
    end
    return self  # ???
  end

  # For backward compatability (TO BE DEPRECATED).

  def assign_from(*args)
    warn "use instance_assume for a future version"
    instance_assume(*args)
  end

  # As with #instance_assume, but forces the setting of the object's
  # instance varaibles even if the reciever doesn't have them defined.
  #
  # See #instance_assume.

  def instance_assume!(obj, *vars)
    if vars.empty?
      vars = obj.instance_variables
    else
      vars = vars.collect do |k|
        var.to_s.slice(0,1) == '@' ? var : "@#{var}"
      end
      vars = vars | obj.instance_variables
    end
    vars.each do |var|
      instance_variable_set(var, obj.instance_variable_get(var))
    end
    return self  # ???
  end

  # Shadow method for instance_assume.
  alias :__assume__ :instance_assume if defined?(instance_assume)

  # Set instance variables using a hash (or assoc array).
  #
  #   instance_assign('@a'=>1, '@b'=>2)
  #   @a   #=> 1
  #   @b   #=> 2
  #
  #--
  # TODO: Make a little more flexiable to allow any hash-like object.
  # TODO: Should is also accept class variables? (eg. @@a)
  # TODO: Should instance_assign be named instance_variable_assign?
  #       Likewise for instance_assume. Is there a better term than 'assume'?
  #++

  def instance_assign(*args)
    harg = args.last.is_a?(Hash) ? args.pop : {}

    unless args.empty?
      # if not assoc array, eg. [ [], [], ... ]
      # preserves order of opertation
      unless args[0].is_a?(Array)
        i = 0; a = []
        while i < args.size
          a << [ args[i], args[i+1] ]
          i += 2
        end
        args = a
      end
    end

    args.each do |k,v|
      k = "@#{k}" if k !~ /^@/
      instance_variable_set(k, v)
    end

    harg.each do |k,v|
      k = "@#{k}" if k !~ /^@/
      instance_variable_set(k, v)
    end

    return self
  end

  # For backward compatability (DEPRECATED).
  alias :assign_with :instance_assign
end
