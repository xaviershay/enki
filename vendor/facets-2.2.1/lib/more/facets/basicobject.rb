# TITLE:
#
#   BasicObject
#
# SUMMARY:
#
#   BasicObject provides an abstract base class with
#   essentially no predefined methods.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer, Jim Weirich
#
# LICENSE:
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# AUTHORS:
#
#   - Jim Weirich
#   - Thomas Sawyer
#
# HISTORY:
#
#   Thanks to Jim Weirich for BlankSlate Copyright (c) 2004 by Jim Weirich,
#   on which BasicObject is based.
#
# TODOs:
#
#   - TODO Might be nice it there were a factory method to alter which methods
#     were excluded. But probably too dangerous.

require 'facets/kernel/object'
require 'facets/kernel/super'

# = BasicObject
#
# BasicObject provides an abstract base class with no predefined
# methods, except for <tt>respond_to?</tt>, any method starting in
# <tt>\_\_</tt> (two underscore, like <tt>\_\_id__</tt>) as well as
# any method starting with <tt>instance_</ttr>.
#
# BasicObject is useful as a base class when writing classes that
# depend upon <tt>method_missing</tt> (e.g. dynamic proxies).
#
# The patterns used to reserve methods are:
#
#    /^__/, /^instance/, /^object/, /\?$/, /^\W$/,
#    'initialize', 'initialize_copy', 'inspect', 'dup', 'clone', 'null', 'as'
#
# By default these are the reserved methods:
#
#   == __id__ __self__ __send__ as clone dup eql? equal? frozen?
#   initialize inspect instance_eval instance_of? instance_variable_get
#   instance_variable_set instance_variables is_a? kind_of? nil? null object_class
#   respond_to? tainted?
#
# In practice only 'as', 'clone', 'dup' and 'null' have much chance of name clash.
# So be especially aware of these four. All the rest either begin with a '__',
# end in a '?' mark or start with the word 'instance' or 'object'.
#
# The special method #object_self allows access to the underlying object via a
# specialized Functor-style class access via as(Object). This binds the
# actual self to the subsequently called methods of Object instancea methods.
# So even though a method may no longer be defined for BasicObject it can still
# be called via this interface.
#
#   class A < BasicObject
#   end
#
#   a.object_self.class  #=> A
#   a.class              #=> NoMethodError
#
# Note that #object_self used to be called __self__. Also provided is #object_class.

class BasicObject

  # Returns the Self functor class, which can then be used to
  # call Kernel/Object methods on the current object.

  def object_self
    @__object_self__ ||= As.new(self, ::Object)
  end
  alias :__self__ :object_self  # deprecate

#--
  # The Self class allows one to get access the hidden Object/Kernel methods.
  # It is essentially a specialized Functor which binds an Object/Kernel
  # method to the current object for the current call.

  #class Self < self
  #  def initialize(obj, as=nil)
  #    @obj = obj
  #    @as = as || ::Object
  #  end
  #  def method_missing(meth, *args, &blk)
  #    @as.instance_method(meth).bind(@obj).call(*args, &blk)
  #  end
  #end

  # This method is like #__self__, but allows any ancestor
  # to act on behalf of self, not just Object.
  #
  #def __as__( ancestor )
  #  Self.new( self, ancestor )
  #end
  #alias_method :as, :__as__

  # Shadow some other important methods.

  #alias_method :__eval__, :eval
  #alias_method :__method__, :method
#++

  # Methods not to get rid of as they are either too important, or
  # they are not likely to get in the way (such as methods ending in '?').
  #
  # In Ruby 1.9 BasicObject has only these methods:
  # [ /^__/, "funcall", "send", "respond_to?", "equal?", "==", "object_id" ]
  #
  # NOTE The absolute bare minimum is EXCLUDE = /^(__|instance_eval$)/.
  # But in most cases you'll want a few extra methods like #dup too.
  #
  #--
  # TODO In the future it might be nice to allow some selectability
  # in these via a factory method.
  #++

  EXCLUDE = [
    /^__/, /^instance_/, /^object_/, /\?$/, /^\W$/,
    'initialize', 'initialize_copy', 'inspect', 'dup', 'clone', 'null', 'as'
  ]

  # Undef unwanted method as long as it doesn't match anything in the EXCLUDE list.

  def self.hide(name)
    #if instance_methods.include?(name.to_s) and name !~ EXCLUDE #/^(#{EXCLUDE.join('|')})/
    #if name !~ EXCLUDE and
    case name
    when *EXCLUDE
      # do nothing
    else
      #if ( public_instance_methods.include?(name.to_s) or
      #     private_instance_methods.include?(name.to_s) or
      #     protected_instance_methods.include?(name.to_s)
      #   )
        undef_method name rescue nil
      #end
    end
  end

  # remove all methods

  public_instance_methods(true).each { |m| hide(m) }
  private_instance_methods(true).each { |m| hide(m) }
  protected_instance_methods(true).each { |m| hide(m) }

#--
  # If the method isn't defined and has the form '__method__'
  # then try sending 'method' to self-as-Object. Remember
  # this will not have any effect if you override it!

  #def method_missing( sym, *args, &blk )
  #  if md = /^__(.+)__$/.match( sym.to_s )
  #    as(Object).__send__( md[1], *args, &blk )
  #  else
  #    super
  #  end
  #end
#++

end

# Since Ruby is very dynamic, methods added to the ancestors of
# BasicObject <em>after BasicObject is defined</em> will show up in the
# list of available BasicObject methods.  We handle this by defining
# hooks in Object, Kernel and Module that will hide any defined.

module Kernel
  class << self
    madded = method(:method_added)
    define_method(:method_added) do |name|
      r = madded.call(name)
      return r if self != Kernel
      BasicObject.hide(name)
      r
    end
  end
end

# See Kernel callback.

class Object
  class << self
    madded = method(:method_added)
    define_method(:method_added) do |name|
      r = madded.call(name)
      return r if self != Object
      BasicObject.hide(name)
      r
    end
  end
end

# Also, modules included into Object need to be scanned and have their
# instance methods removed from blank slate.  In theory, modules
# included into Kernel would have to be removed as well, but a
# "feature" of Ruby prevents late includes into modules from being
# exposed in the first place.
=begin
class Module
  if method_defined?(:append_features)
    mappended = method(:append_features)
  else
    mappended = nil
  end
  define_method(:append_features) do |mod|
    r = mappended.call(mod) if mappended
    return r if mod != Object
    public_instance_methods(true).each { |name| BasicObject.hide(name) }
    private_instance_methods(true).each { |name| BasicObject.hide(name) }
    public_instance_methods(true).each { |name| BasicObject.hide(name) }
    r
  end
end
=end

