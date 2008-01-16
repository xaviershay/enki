# TITLE:
#
#   Prepend
#
# DESCRIPTION:
#
#   Presend a module to another module, or to a class.
#
# COPYRIGHT:
#
#   Copyright (c) 2007 Thomas Sawyer
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
class Module

  # Prepend an +aspect+ module to a module.
  #
  #   module X
  #     def x; "x"; end
  #   end
  #
  #   module U
  #     def x; '{' + super + '}'; end
  #   end
  #
  #   X.prepend U
  #
  #   X.x  # => "{x}"

  def prepend( aspect )
    aspect.send(:include, self)
    extend aspect
  end

end


#
class Class

  # Prepend an +aspect+ module to a class.
  #
  # class Firetruck
  #   def put_out_fire(option)
  #     "Put out #{option}"
  #   end
  # end
  #
  # module FastFiretruck
  #   def put_out_fire(option)
  #     super("very #{option}!")
  #   end
  # end
  #
  # Firetruck.prepend(FastFiretruck)
  #
  # ft = Firetruck.new
  # ft.put_out_fire('fast') #=> "Put out very fast!"

  def prepend( aspect )
    _new      = method(:new)
    _allocate = method(:allocate)
    (class << self; self; end).class_eval do
      define_method(:new) do |*args|
        o = _new.call(*args)
        o.extend aspect
        o
      end
      define_method(:allocate) do |*args|
        o = _allocate.call(*args)
        o.extend aspect
        o
      end
    end
  end

end
