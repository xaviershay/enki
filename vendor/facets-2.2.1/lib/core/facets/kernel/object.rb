# = TITLE:
#
#   Object Methods
#
# = DESCRIPTION:
#
#   Kernel extension using object_ prefix which is beneficial
#   to separation of metaprogramming from general programming.
#   object_ methods, in contrast to the instance_ methods,
#   do not access internal state.
#
# = AUTHORS:
#
#   - Thomas Sawyer

module Kernel

  # Defines object_classas an alias of class.
  # This is an alternative to __class__, akin to
  # #object_id.

  alias_method :object_class, :class

  alias_method :object_dup  , :dup
  alias_method :object_clone, :clone

  # Returns the object id as a string in hexideciaml,
  # which is how Ruby reports them with inspect.
  #
  #   "ABC".object_hexid  #=> "0x402d359c"

  def object_hexid
    return "0x" << ('%.x' % (2*self.__id__))[1..-1]
  end

  # Send only to public methods.
  #
  #   class X
  #     private
  #     def foo; end
  #   end
  #
  #   X.new.object_send(:foo)
  #   => NoMethodError: private method `foo' called for #<X:0xb7ac6ba8>
  #
  #   CREDIT: Trans
  #--
  # Which implementation is faster?
  #++

  def object_send(name,*args,&blk)
    #instance_eval "self.#{name}(*args)"
    if respond_to?(name)
      send(name,*args,&blk)
    else #if respond_to?(:method_missing)
      method_missing(name,*args,&blk)
    #else
    #  raise NoMethodError
    end
  end

  # Defines core method __class__ as an alias of class.
  # This allows you to use #class as your own method, without
  # loosing the ability to determine the object's class.

  alias :__class__ :class

end
