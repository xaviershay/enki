# TITLE:
#
#   Aspect Oriented Programming for Ruby
#
# SUMMARY:
#
#
# AUTHORS:
#
#   - Thomas Sawyer
#
# NOTES:
#
#    - Can JointPoint and Target be the same class?

require 'facets/kernel/object'
require 'facets/module/methods'
require 'facets/cut'

#

class Aspect < Module

  def initialize(&block)
    instance_eval(&block)
    extend self
  end

  def points
    @points ||= {}
  end

  # TODO Should this accept pattern matches as an alternative to the block too?
  #      Eg. join(name, pattern=nil, &block)
  def join(name, &block)
    (points[name] ||= []) << block
  end

end

#

class Joinpoint
  def initialize(object, base, method, *args, &block)
    @object = object
    @base   = base
    @method = method
    @args   = args
    @block  = block
  end

  def ===(match)
    case match
    when Proc
      match.call(self)
    else # Pattern matches (not supported presently)
      match.to_sym == @method.to_sym
    end
  end

  def ==(sym)
    sym.to_sym == @method.to_sym
  end

  #

  def super
    anc = @object.class.ancestors.find{ |anc| anc.method_defined?(@method) }
    anc.instance_method(@method).bind(@object).call(*@args, &@block)
  end
end


#   module LogAspect
#     extend self
#
#     join :log do |jp|
#       jp.name == :x
#     end
#
#     def log(target)
#       r = target.super
#       ...
#       return r
#     end
#   end
#
#   class X


class Target

  def initialize(aspect, advice, *target, &block)
    @aspect = aspect
    @advice = advice
    @target = target
    @block  = block
  end

  def super
    @aspect.send(@advice, *@target, &@block)
  end

  alias_method :call, :super
end


def cross_cut(klass)
  Cut.new(klass) do
    define_method :__base__ do klass end

    all_instance_methods.each do |meth|
      undef_method(meth) unless meth.to_s =~ /(^__|initialize$|p$|class$|inspect$)/
    end

    #def initialize(base, *args, &block)
    #  @base     = base
    #  @delegate = base.__new(*args, &block)
    #  @advices  = {}
    #end

    def method_missing(sym, *args, &blk)
#  p "METHOD MISSING: #{sym}" #if DEBUG

      @advices ||= {}

      base = __base__

      jp = Joinpoint.new(self, base, sym, *args, &blk)

      # calculate advices on first use.
      unless @advices[sym]
        @advices[sym] = []
        base.aspects.each do |aspect|
          aspect.points.each do |advice, matches|
            matches.each do |match|
              if jp === match
                @advices[sym] << [aspect, advice]
              end
            end
          end
        end
      end

      target = jp #Target.new(self, sym, *args, &blk)  # Target == JoinPoint ?

      @advices[sym].each do |(aspect, advice)|
        target = Target.new(aspect, advice, target)
      end

      target.super
    end
  end
end


#

class Class
  #def cut; @cut; end
  def aspects; @aspects ||= []; end

  def apply(aspect)
    if aspects.empty?
      cross_cut(self)
      #(class << self;self;end).class_eval do
      #  alias_method :__new, :new
      #  def new(*args, &block)
      #    CrossConcerns.new(self,*args, &block)
      #  end
      #end
    end
    aspects.unshift(aspect)
  end

end


=begin demo

  class X
    def x; "x"; end
    def y; "y"; end
    def q; "<" + x + ">"; end
  end

  Xa = Aspect.new do
    join :x do |jp|
      jp == :x
    end

    def x(target); '{' + target.super + '}'; end
  end

  X.apply(Xa)

  x1 = X.new
  #print 'X == '          ; p x1
  print 'X == '          ; p x1.class
  print '["q", "y", "x"] == ' ; p x1.public_methods(false)
  print '"{x}" == '      ; p x1.x
  print '"y" == '        ; p x1.y
  print '"<{x}>" == '    ; p x1.q

=end
