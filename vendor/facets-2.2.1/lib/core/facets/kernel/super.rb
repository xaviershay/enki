# = TITLE:
#   Super/As Extensions
#
# = DESCRIPTION:
#   Extensions for calling ancestor methods.
#
# = AUTHORS:
#   CREDIT Thomas Sawyer
#
# = LOG:
#   - 2006-11-04  trans@gmail.com  Use own delegator instead of Functor.
#   - 2006-11-04  trans@gmail.com  Now #as can take a block.
#
# = TODO:
#
#   - Probably get rid of __self__ or get a new name.
#     It is similar to #meta + #as, but just for Object/Kernel.
#
#   - Deprecatee either #super_method or #supermethod.

require 'facets/functor'

module Kernel

  # Returns a Functor that allows one to call any
  # Kernel or Object method bound to self, making it
  # possible to bypass overrides of Kernel and Object
  # methods.
  #
  #   class A
  #     def object_id ; "OBTUSE" ; end
  #   end
  #
  #   c = C.new
  #   c.object_id         #=> "OBTUSE"
  #   c.__real__.object_id    #=> 6664875832
  #
  # NOTE: This has been through a couple of renamings,
  # including #__object__, #__self__, and #self.

  def __real__
    @__real__ ||= Functor.new do |meth, *args|  # &blk|
      Object.instance_method(meth).bind(self).call(*args) # ,&blk)
    end
  end

  # Returns a As-functor that allows one to call any
  # ancestor's method directly of the given object.
  #
  #   class A
  #     def x ; 1 ; end
  #   end
  #
  #   class B < A
  #     def x ; 2 ; end
  #   end
  #
  #   class C < B
  #     def x ; as(A).x ; end
  #   end
  #
  #   C.new.x  #=> 1

  def as(ancestor, &blk)
    @__as ||= {}
    unless r = @__as[ancestor]
      r = (@__as[ancestor] = As.new(self, ancestor))
    end
    r.instance_eval(&blk) if block_given?
    #yield(r) if block_given?
    r
  end

  # Call parent class/module methods once bound to self.

  def send_as(ancestor, sym, *args, &blk)
    ancestor.instance_method(sym).bind(self).call(*args,&blk)
  end

  #--
  #   def send_as(klass, meth, *args, &blk)
  #     selfclass = Kernel.instance_method(:class).bind(self).call
  #     raise ArgumentError if ! selfclass.ancestors.include?(klass)
  #     klass.instance_method(meth).bind(self).call(*args, &blk)
  #   end
  #++

  #--
  #   def as( role, &blk )
  #     unless role.is_a?(Class)
  #       role = self.class.const_get( role )
  #     end
  #     @roles ||= {}
  #     @roles[role] ||= role.allocate
  #     robj = @roles[role]
  #     robj.assign_from( self )
  #     result = robj.instance_eval( &blk )
  #     self.assign_from( robj )  # w/o this much like namespaces
  #     result
  #   end
  #++

  # Like super but skips to a specific ancestor module or class.
  #
  #   class A
  #     def x ; 1 ; end
  #   end
  #
  #   class B < A
  #     def x ; 2 ; end
  #   end
  #
  #   class C < B
  #     def x ; superior(A) ; end
  #   end
  #
  #   C.new.x  #=> 1

  def super_at(klass=self.class.superclass, *args, &blk)
    unless self.class.ancestors.include?(klass)
      raise ArgumentError
    end
    called = /\`([^\']+)\'/.match(caller(1).first)[1].to_sym
    klass.instance_method(called).bind(self).call(*args,&blk)
  end

  # For backward compatability.
  alias_method :superior, :super_at

  # Returns method of a parent class bound to self.

  def super_method(klass, meth)
    unless self.class.ancestors.include?(klass)
      raise ArgumentError, "Not an ancestor for super_method-- #{klass}"
    end
    klass.instance_method(meth).bind(self)
  end

  # TODO Deprecate -- don't need two methods for the same thing,
  alias_method :supermethod, :super_method

end

# Support class for Kernel#as.

class As #:nodoc:
  # Privatize all methods except #binding an operators.
  private(*instance_methods.select { |m| m !~ /(^__|^\W|^binding$)/ })

  def initialize(subject, ancestor)
    @subject = subject
    @ancestor = ancestor
  end

  def method_missing(sym, *args, &blk)
    @ancestor.instance_method(sym).bind(@subject).call(*args,&blk)
  end
end
