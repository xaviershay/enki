# TITLE:
#
#   Parametric Mixins
#
# SUMMARY:
#
#   Parametric Mixins provides parameters for mixin modules.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer, George Moschovitis
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
#   - George Moschovitis

require 'facets/module/name' # for basename

# = Parametric Mixins
#
# Parametric Mixins provides parameters for mixin modules.
# Module parameters can be set at the time of inclusion or extension,
# then accessed via an instance method of the same name as the included
# module.
#
# == Synopsis
#
#   module Mixin
#     def hello
#       puts "Hello from #{Mixin(:name)}"
#     end
#   end
#
#   class MyClass
#     include Mixin, :name => 'Ruby'
#   end
#
#   m = MyClass.new
#   m.hello -> 'Hello from Ruby'
#
# You can view the full set of parameters via the #mixin_parameters
# class method, which returns a hash keyed on the included modules.
#
#   MyClass.mixin_parameters         #=> {Mixin=>{:name=>'Ruby'}}
#   MyClass.mixin_parameters[Mixin]  #=> {:name=>'Ruby'}
#
# To create _dynamic mixins_ you can use the #included callback
# method along with mixin_parameters method like so:
#
#   module Mixin
#     def self.included( base )
#       parms = base.mixin_parameters[self]
#       base.class_eval {
#         def hello
#           puts "Hello from #{parms(:name)}"
#         end
#       }
#     end
#   end
#
# More conveniently a new callback has been added, #included_with_parameters,
# which passes in the parameters in addition to the base class/module.
#
#   module Mixin
#     def self.included_with_parameters( base, parms )
#       base.class_eval {
#         def hello
#           puts "Hello from #{parms(:name)}"
#         end
#       }
#     end
#   end
#
# We would prefer to have passed the parameters through the #included callback
# method itself, but implementation of such a feature is much more complicated.
# If a reasonable solution presents itself in the future however, we will fix.

class Module

  # Store for module parameters. This is local per module
  # and indexed on module/class included-into.
  def mixin_parameters ; @mixin_parameters ||= {} ; end

  alias_method :include_without_parameters, :include

  def include(*args)
    params = args.last.is_a?(Hash) ? args.pop : {}
    args.each do |mod|
      mixin_parameters[mod] = params
      if mod.basename
        define_method( mod.basename ) do |key|
          if params.key?(key)
            params[key]
          else
            super if defined?( super )
          end
        end
      end
    end
    r = include_without_parameters(*args)
    for mod in args
      if mod.respond_to?(:included_with_parameters)
        mod.included_with_parameters( self, params )
      end
    end
    r
  end

  alias_method :extend_without_parameters, :extend

  def extend(*args)
    params = args.last.is_a?(Hash) ? args.pop : {}
    args.each do |mod|
      (class << self; self; end).class_eval do
        mixin_parameters[mod] = params
        if mod.basename
          define_method( mod.basename ) do |key|
            if params.key?(key)
              params[key]
            else
              super if defined?( super )
            end
          end
        end
      end
    end
    r = extend_without_parameters(*args)
    for mod in args
      if mod.method_defined?(:extended_with_parameters)
        mod.extended_with_parameters( self, params )
      end
    end
    r
  end

end
