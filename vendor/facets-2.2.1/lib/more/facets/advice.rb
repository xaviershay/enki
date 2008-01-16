# = TITLE:
#
#   Advice
#
# = SUMMARY:
#
#   Add before, after and around advice in dynamic fashion.
#
# = COPYRIGHT:
#
#   Copyright (c) 2007 Thomas Sawyer
#
# = LICENSE:
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
# = AUTHORS:
#
#   - TransAspect

require 'facets/1stclassmethod'
require 'facets/unboundmethod/arguments'
#require 'facets/binding'

#
class Method
  attr_accessor :advised

  attr_reader :advice_before
  attr_reader :advice_after
  attr_reader :advice_around

  def advised?
    @advised
  end

  def advice_before=(set); @advice_before = set.flatten.compact; end
  def advice_after=(set) ;  @advice_after = set.flatten.compact; end
  def advice_around=(set); @advice_around = set.flatten.compact; end

  # Call with advice.

  def call_with_advice(obj, *args, &blk)
    advice_before.each do |name|
      #advice.call(*args, &blk)
      obj.send(name, *args, &blk)
    end

    target = lambda{ call(*args, &blk) }
    advice_around.each do |name|
      target = lambda_target(obj, name, target, *args, &blk)
    end
    ret = target.call

    advice_after.reverse_each do |name|
      #advice.call(*args, &blk)
      obj.send(name, *args, &blk)
    end

    return ret
  end

  private

  # Using separate method for this prevents infinite loop.

  def lambda_target(obj, name, target, *args, &blk)
    lambda do
      #advice.call(target, *args, &blk)
      obj.send(name, target, *args, &blk)
    end
  end

end


module Advisable
#class Module

  def advice_before
    @advice_before ||= {} #Hash.new{|h,k| h[k] = []}
  end

  def advice_after
    @advice_after ||= {} #Hash.new{|h,k| h[k] = []}
  end

  def advice_around
    @advice_around ||= {} #Hash.new{|h,k| h[k] = []}
  end

  def before(meth, &block)
    name = "#{meth}:before#{block.object_id}"
    define_method(name, &block)
    (advice_before[meth.to_sym] ||= []) << name
  end

  def after(meth, &block)
    name = "#{meth}:after#{block.object_id}"
    define_method(name, &block)
    (advice_after[meth.to_sym] ||= []) << name
  end

  def around(meth, &block)
    name = "#{meth}:around#{block.object_id}"
    define_method(name, &block)
    (advice_around[meth.to_sym] ||= []) << name
  end

  # Advise a method.

  def advise(meth)
    #return false if defined?(meth_origin)
    args = instance_method(meth).arguments

    module_eval(<<-END, __FILE__, __LINE__)
      alias_method '#{meth}_origin', '#{meth}'
      def #{meth}(#{args})
        target = method!('#{meth}_origin')

        unless target.advised
          ancs = self.class.ancestors.select{ |anc| anc.respond_to?(:advice_before) }
          target.advice_before = ancs.collect{ |anc| anc.advice_before[:'#{meth}'] }
          target.advice_after  = ancs.collect{ |anc| anc.advice_after[:'#{meth}'] }
          target.advice_around = ancs.collect{ |anc| anc.advice_around[:'#{meth}'] }
          target.advised = true
        end

        target.call_with_advice(self, *[#{args}])
      end
    END
  end

  #advise(:method_added)

  #after :method_added do |meth|
  #  advise(meth) unless defined?("#{meth}_orig")
  #end

  def method_added(meth)
    return if meth == :method_added
    @added_stack ||= []
    return if @added_stack.last == meth
    return if /_(origin)$/ =~ meth.to_s
    return if /:(before|after|around)/ =~ meth.to_s
    @added_stack << meth
    #return if instance_methods(false).include?("#{meth}_orig")
    advise(meth)
    @added_stack.pop
  end

end
