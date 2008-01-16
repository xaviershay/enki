# TITLE:
#   Prototype
#
# SUMMARY:
#   Prototype-base Object-Oriented programming.
#
# COPYRIGHT:
#   Copyright (c) 2006, 2007 Thomas Sawyer


# = Prototype class

class Prototype

  # New prototype object.

  def initialize(&block)
    @traits = []

    instance_eval(&block)

    h = {}
    iv = instance_variables
    iv.each { |k| h[k[1..-1].to_sym] = instance_eval{ instance_variable_get(k) } }
    meta.class_eval do
      h.each do |k,v|
        case v
        when Proc
          #define_method(k){ |*args| v[*args] }
          attr_reader k
        else
          attr_accessor k
        end
      end
    end
  end

  def fn(&blk)
    proc(&blk)
  end

  def new(o=nil)
    return o.clone if o
    return clone
  end

  def meta
   (class << self; self; end)
  end

  def traits
    @traits
  end

  def trait(obj)
    traits << obj.new
  end

  def method_missing(s, *a, &b)
    if trait = traits.find{ |t| t.method_defined?(s) }
      trait.send(s,*a,&b)
    else
      super
    end
  end

end


module Kernel

  def prototype(&block)
    Prototype.new(&block)
  end

  #private

  # Synonymous with #clone, this is an interesting
  # method in that it promotes prototype-based Ruby.
  # Now Classes aren't the only things that respond to #new.
  #
  #   "ABC".new  => "ABC"
  #
  def new(o=nil)
    return o.clone if o
    return clone
  end

end
