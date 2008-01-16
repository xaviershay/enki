# TITLE:
#
#   Interface
#
# SUMMARY:
#
#   These two interface methods provide a more concise alternative to
#   Ruby's reflection on class/module methods. Ruby's has these:
#
#     methods                instance_methods
#     public_methods         public_instance_methods
#     protected_methods      protected_instance_methods
#     private_methods        private_instance_methods
#                            singleton_methods
#
#  Each of these additionally take an ancestoral parameter. And to
#  matters worse, #methods and #instance_methods are aliases for
#  #public_methods and #public_instance_methods respectively, rather
#  then the collection of all methods, which can be confusing.
#
#  The interface library simplifies all this by providing just two
#  methods to do all of the above: #interface and #instance_interface.
#  Symbolic parameters are passed to either of these methods as a means
#  of categorization of method type, providing a much more flexible
#  means of examing object class and  module interfaces.
#
#  Some examples:
#
#    Proc.instance_interface(:public, :inherited)
#
#    "a string".interface(:singleton)
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer
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
#   - Thomas Sawyer


require 'facets/symbol/not'

#
class Module

  unless const_defined?('METHOD_TYPES')
  METHOD_TYPES = [
    :inherited, :ancestors, :local,
    :public, :private, :protected,
    :all
  ]
  end

  # Provides an improved method lookup routnine.
  # It returns a list of methods according to symbol(s) given.
  #
  # Recognized symbols are:
  #
  # * <tt>:public</tt>     include public methods
  # * <tt>:private</tt>    include private methods
  # * <tt>:protected</tt>  include protected methods
  # * <tt>:ancestors</tt>  include all ancestor's methods
  # * <tt>:inherited</tt>  (same as above)
  # * <tt>:local</tti>     include non-ancestor methods
  # * <tt>:all</tt>        include all of the above
  #
  # This method also uses the symbol-not system. So you can specify
  # the inverse of all of the above. For instance ~:public would mean
  # :private, :protected (see facets/symbol/not).
  #
  # If no symbol is given then :public, :local is assumed.
  # Unrecognized symbols raise an error.
  #
  #   module Demo
  #     def test
  #       puts("Hello World!")
  #     end
  #   end
  #
  #   Demo.instance_methods(:local)    #=> ['test']
  #
  # To maintain backward compatibility <tt>true</tt> as an intitial argument
  # is converted to :local, :ancestors (i.e. it includes both).
  #
  def instance_interface(*args)

    # for backward compatibility
    args << true if args.empty?

    case args[0]
    when TrueClass
      args.shift
      args << :ancestors
      args << :local
    when FalseClass
      args.shift
      args << :local
    end

    # default public, local
    args |= [:public] unless [:publix,:private,:protected,:all].any?{ |a| args.include?(a) }
    args |= [:ancestors,:local] unless [:ancestors,:inherited,:local,:all].any?{ |a| args.include?(a) }

    raise ArgumentError if args.any?{ |a| ! METHOD_TYPES.include?(a) }

    pos, neg = args.partition { |s| ! s.not? }

    m = []

    pos.each do |n|
      case n
      when :inherited, :ancestors
        m |= ( public_instance_methods( true ) - public_instance_methods( false ) )       if pos.include?(:public)
        m |= ( private_instance_methods( true ) - private_instance_methods( false ) )     if pos.include?(:private)
        m |= ( protected_instance_methods( true ) - protected_instance_methods( false ) ) if pos.include?(:protected)
      when :local
        m |= public_instance_methods( false )    if pos.include?(:public)
        m |= private_instance_methods( false )   if pos.include?(:private)
        m |= protected_instance_methods( false ) if pos.include?(:protected)
      when :all
        m |= public_instance_methods( true )
        m |= private_instance_methods( true )
        m |= protected_instance_methods( true )
      end
    end

    neg.each do |n|
      case n
      when :public
        m -= public_instance_methods( true )
      when :private
        m -= private_instance_methods( true )
      when :protected
        m -= protected_instance_methods( true )
      when :inherited, :ancestors
        m -= ( public_instance_methods( true ) - public_instance_methods( false ) )
        m -= ( private_instance_methods( true ) - private_instance_methods( false ) )
        m -= ( protected_instance_methods( true ) - protected_instance_methods( false ) )
      when :local
        m -= public_instance_methods( false )
        m -= private_instance_methods( false )
        m -= protected_instance_methods( false )
      end
    end

    m.sort
  end

  # old-version
  #     args << :public unless ( args.include?(:private) or args.include?(:protected) )
  #     args[0] = [ :ancestors, :local ] if TrueClass === args[0]
  #     args.flatten!
  #     raise ArgumentError if args.any?{ |a| ! METHOD_SYMBOLS.include?(a) }
  #     m = []
  #     a = args.include?( :all )
  #     i = ( args.include?( :inherited ) or args.include?( :ancestors ) )
  #     l = ( args.include?( :local ) or args.include?( :no_ancestors ) )
  #     if a
  #       m |= public_instance_methods( true )
  #       m |= private_instance_methods( true )
  #       m |= protected_instance_methods( true )
  #     elsif i and l
  #       m |= public_instance_methods( true ) if args.include?( :public )
  #       m |= private_instance_methods( true ) if args.include?( :private )
  #       m |= protected_instance_methods( true ) if args.include?( :protected )
  #     elsif i
  #       m |= (public_instance_methods( true ) - public_instance_methods( false )) if args.include?( :public )
  #       m |= (private_instance_methods( true ) - private_instance_methods( false )) if args.include?( :private )
  #       m |= (protected_instance_methods( true ) - protected_instance_methods( false )) if args.include?( :protected )
  #     else
  #       m |= public_instance_methods( ! l ) if args.include?( :public )
  #       m |= private_instance_methods( ! l ) if args.include?( :private )
  #       m |= protected_instance_methods( ! l ) if args.include?( :protected )
  #     end
  #     m

end


#
module Kernel

  # Returns a list of methods according to symbol(s) given.
  #
  # Usable symbols include:
  #
  # * <tt>:inherited</tt> or <tt>:ancestors</tt>
  # * <tt>:local</tt> or <tt>:no_ancestors</tt>
  # * <tt>:public</tt>
  # * <tt>:private</tt>
  # * <tt>:protected</tt>
  # * <tt>:singleton</tt>
  # * <tt>:all</tt>
  #
  # It no symbol is given then :public is assumed.
  # Unrecognized symbols raise an error.
  #
  #   def test
  #     puts("Hello World!")
  #   end
  #
  #   methods(:local)    #=> ['test']
  #
  def interface(*args)
    args = [ :public, :local, :ancestors, :singleton ] if args.empty?
    sing = args.delete(:singleton) or args.include?(:all)
    if sing
      if args.empty?
        singleton_methods
      else
        singleton_methods | self.class.instance_interface(*args)
      end
    else
       self.class.instance_interface(*args)
    end
  end

end
