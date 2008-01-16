# TITLE:
#
#   Behavior
#
# SUMMARY:
#
#   Create temporary extensions.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Nobuyoshi Nakada
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
#   - Nobuyoshi Nakada
#
# TODOs:
#
#   - What was it? Something about Namespace...


# = Behavior
#
class Behavior < Module
  #
  def define(behavior, &body)
    if body
      define_method(behavior, &body)
    else
      behavior.each do |behavior, body|
        if body
          define_method(behavior, &body)
        elsif body.nil?
          remove_method(behavior)
        else
          undef_method(behavior)
        end
      end
    end
  end
end

module Kernel
  #
  def behaving(behavior, &body)
    unless @_behaviors
      extend(@_behaviors = Behavior.new)
    end
    @_behaviors.define(behavior, &body)
  end
end


# OLD IMPLEMENTATION

=begin
class Behavior < Module
    def initialize(behavior, &body)
    if body
      define_method(behavior, &body)
    else
      behavior.each do |behavior, body|
        if body
          define_method(behavior, &body)
        elsif body.nil?
          remove_method(behavior)
        else
          undef_method(behavior)
        end
      end
    end
  end
end

module Kernel
  def behaving(behavior, &body)
    extend(Behavior.new(behavior, &body))
  end
end
=end
