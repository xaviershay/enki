require 'facets/functor'

module Kernel

  # Provides access to an object's metaclass (ie. singleton)
  # by-passsing access provisions. So for example:
  #
  #   class X
  #     meta.attr_accesser :a
  #   end
  #
  #   X.a = 1
  #   X.a #=> 1
  #
  #  CREDIT: Trans

  def meta
    @_meta_functor ||= Functor.new do |op,*args|
      (class << self; self; end).send(op,*args)
    end
  end

  # Alias a method defined in the metaclass (ie. singleton class).
  #
  #   def X.y?; "y?" ; end
  #   X.meta_alias "ynot?", "y?"
  #   X.ynot?  #=> y?
  #
  #   CREDIT: Trans

  def meta_alias(*args)
    meta_class do
      alias_method(*args)
    end
  end

  # Evaluate code in a metaclass. This is equivalent to
  # 'meta_class.instance_eval'.
  #
  #   CREDIT: WhyTheLuckyStiff

  def meta_eval(str=nil, &blk)
    if str
      meta_class.instance_eval(str)
    else
      meta_class.instance_eval(&blk)
    end
  end

  # Add method to a meta-class --i.e. a singleton method.
  #
  #   class X; end
  #   X.meta_def(:x){"x"}
  #   X.x  #=> "x"
  #
  #   CREDIT: WhyTheLuckyStiff

  def meta_def( name, &block )
    meta_class do
      define_method( name, &block )
    end
  end

  # Easy access to an object's "special" class,
  # otherwise known as it's metaclass or singleton class.

  def meta_class(&block)
    if block_given?
      (class << self; self; end).class_eval(&block)
    else
      (class << self; self; end)
    end
  end
  alias_method :metaclass, :meta_class

  # During this trying time when no one can get their
  # techie catchwords to stick to the refrigerator no
  # matter how hard they slap it # with the enchanted
  # magnetic spatula, it’s good to know that the
  # contrived phrases really do fly, graceful and
  # unclasped and bearing north toward chilled shrimp.
  # I know what my Hallowe’en pumpkin is going to say.
  #
  #                       -- why the lucky stiff
  #
  #   CREDIT: WhyTheLuckyStiff

  def eigenclass
    (class << self; self; end)
  end

  # Access to an object's "special" class, otherwise
  # known as it's eigenclass or metaclass, etc.
  #
  # One day these names must be reconciled!

  def singleton
    (class << self; self; end)
  end

  # Access to an object's "special" class, otherwise
  # known as it's eigenclass or metaclass or own, etc.
  #
  # One day these names must be reconciled!

  def singleton_class
    (class << self; self; end)
  end
  alias_method :__singleton_class__, :singleton_class

  # Easy access to an object qua class, otherwise
  # known as the object's metaclass or singleton class.
  #
  # Yes, another one.
  #
  #   CREDIT: Trans

  def qua_class(&block)
    if block_given?
      (class << self; self; end).class_eval(&block)
    else
      (class << self; self; end)
    end
  end

  # Universal assignment. This is a meta-programming
  # method, which allows you to assign any type of variable.
  #
  #   CREDIT: Trans

  def __assign__(name, value)
    k = name.to_s
    v = value
    /^([@$]{0,2})/ =~ k
    case $1
    when '$', '@@'
      instance_eval %Q{ #{k} = v }
    when '@'
      instance_variable_set( k, v )
    else
      return __send__( "#{k}=", v ) if respond_to?("#{k}=")
      # No accessor? What to do? Assume instance var, or error? ...
      self.instance_variable_set( "@#{k}", v )
    end
    return value
  end
end


class Module

  # Defines an instance method within a class.
  #
  #   CREDIT: WhyTheLuckyStiff

  def class_def name, &blk
    class_eval { define_method name, &blk }
  end

end
