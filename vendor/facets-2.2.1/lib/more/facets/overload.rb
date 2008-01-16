# TITLE:
#
#   Overload
#
# SUMMARY:
#
#   Write methods with signitures.
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


#
class Module

  def method_overloads
    @method_overloads ||= {}
  end

  # Overload methods.
  #
  #   class X
  #     def x
  #       "hello"
  #     end
  #
  #     overload :x, Integer do |i|
  #       i
  #     end
  #
  #     overload :x, String, String do |s1, s2|
  #       [s1, s2]
  #     end
  #   end

  def overload( name, *signiture, &block )
    name = name.to_sym

    if method_overloads.key?( name )
      method_overloads[name][signiture] = block

    else
      method_overloads[name] = {}
      method_overloads[name][signiture] = block

      if method_defined?( name )
        #method_overloads[name][nil] = instance_method( name ) #true
        alias_method( "#{name}Generic", name )
        has_generic = true
      else
        has_generic = false
      end

      define_method( name ) do |*args|
        ovr = self.class.method_overloads["#{name}".to_sym]
        sig = args.collect{ |a| a.class }
        hit = nil
        faces = ovr.keys.sort { |a,b| b.size <=> a.size }
        faces.each do |cmp|
          next unless cmp.size == sig.size
          cmp.size.times { |i|
            next unless cmp[i] < sig[i]
          }
          hit = cmp
        end

        if hit
          ovr[hit].call(*args)
        else
          if has_generic #ovr[nil]
            send( "#{name}Generic", *args )
            #ovr[nil].bind(self).call(*args)
          else
            raise NoMethodError
          end
        end

      end

    end

  end

end
