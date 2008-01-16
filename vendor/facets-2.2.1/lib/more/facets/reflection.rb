# TITLE:
#
#   Reflection
#
# SUMMARY:
#
#   Provides externailze, safe access to an object's meta-information.
#
# COPYRIGHT:
#
#   Copyright (c) 2006 Thomas Sawyer
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


#
class << ObjectSpace
  alias_method :[], :_id2ref
end

#
class ObjectReflection

  REFLECTION_METHODS = [
    :object_id, :class, :methods, :send
  ] + Kernel.instance_methods.select{ |m| m =~ /^object_/ }

  def initialize(object)
    @self = object
    @meta = REFLECTION_METHODS.inject({}) do |rproc, meth|
      rproc[meth.to_sym] = Kernel.instance_method(meth).bind(@self)
      rproc
    end
  end

  #

  def id
    @meta[:object_id].call
  end

  REFLECTION_METHODS.each do |meth|
    meth = meth[7..-1] if meth =~ /^object_/
    module_eval %{
      def #{meth}(*a,&b)
        rproc[:#{meth}].call(*a,&b)
      end
    }
  end

end

#
class InstanceReflection < ObjectReflection

  REFLECTION_METHODS = [
    :send
  ] + Kernel.instance_methods.select{ |m| m =~ /^instance_/ }

  def initialize(object)
    @self = object
    @meta = REFLECTION_METHODS.inject({}) do |rproc, meth|
      rproc[meth.to_sym] = Kernel.instance_method(meth).bind(@self)
      rproc
    end
  end

  REFLECTION_METHODS.each do |meth|
    meth = meth[7..-1] if meth =~ /^instance_/
    module_eval %{
      def #{meth}(*a,&b)
        rproc[:#{meth}].call(*a,&b)
      end
    }
  end

end


module Kernel

  def object
    @_object_reflection ||= ObjectReflection.new(self)
  end

  def instance
    @_instance_reflection ||= InstanceReflection.new(self)
  end

end
