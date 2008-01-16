# TITLE:
#
#   Dependency
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
# NOTES:
#
#   - The #included call back does a comparison to Object.
#     This is a bit of a hack b/c there is actually no way to
#     check if it is the toplevel --a flaw w/ Ruby's toplevel proxy.
#
# TODOS:
#
#   - Need to be more flexible with passing arguments to
#     dependency methods.
#
#   - Avoid global variable. How?

require 'facets/conversion'  # for Hash#to_h

$toplevel = self

# = MethodDependency
#
# This module is included in Object and allows methods to be given prerequisite
# dependencies, i.e. methods that must be run before they are.
#
# A dependency will only ever be run once per method call.
#
# == Synopis
#
#   include MethodDependency
#
#   def one; @str << '1'; end
#   def two; @str << '2'; end
#
#   def show; @str ; end
#
#   depend :show => [ :x, :y ]
#
#   show  #=> '12'
#
# You can add this functionality to the whole system
# by simply including it at the toplevel.

class Module

  #def self.included( base )
  #  if base == Object #$toplevel
  #    require 'facets/remain.rb'
  #  end
  #end

  #

  def depend( name_and_deps=nil )
    if Hash === name_and_deps
      name_and_deps.to_h.each do |name, deps|
        deps = [deps].flatten
        define_dependency(name, *deps)
      end
    elsif name_and_deps
      @dependency ||= {}
      @dependency[name_and_deps.to_sym]
    else
      @dependency ||= {}
    end
  end

  # Compile list of all unique prerequisite calls.

  def dependencies(name, build=[])
    @dependency ||= {}
    deps = @dependency[name.to_sym]
    return build unless deps
    deps.each do |dep|
      build.unshift(dep)
      dependencies(dep,build)
    end
    build.uniq!
    build
  end

  #

  def define_dependency( name, *deps )
    @dependency ||= {}
    if @dependency[name.to_sym]
      @dependency[name.to_sym] = deps
    else
      @dependency[name.to_sym] = deps
      deplist = lambda{ dependencies(name) }
      alias_method("#{name}:execute",name)
      define_method(name) do |*a|
        # run dependencies
        deplist.call.each do |d|
          if respond_to?("#{d}:execute")
            send("#{d}:execute",*a) #,&b)
          else
            send(d,*a) #,&b)
          end
        end
        # run core method
        send("#{name}:execute",*a) #,&b)
      end
    end
  end

end

class RecursiveDependency < StandardError; end


#class Module
#  include MethodDependency
#end


=begin test

  require 'test/unit'

  class DependableTest1 < Test::Unit::TestCase

    class C
      #extend MethodDependency

      attr :s
      def initialize
        @s = ''
      end

      def x ; @s << 'x'; end
      def y ; @s << 'y'; end
      def z ; @s << 'z'; end

      depend :x => :y
      depend :z => [:x, :y]
    end

    module M
      #extend MethodDependency

      attr :s
      def initialize
        @s = ''
      end

      def x ; @s << 'x'; end
      def y ; @s << 'y'; end
      def z ; @s << 'z'; end

      depend :x => :y
      depend :z => [:x, :y]
    end

    class D
      include M
    end

    def test_01
      c = C.new
      c.x
      assert_equal( 'yx', c.s )
    end

    def test_02
      c = C.new
      c.z
      assert_equal( 'yxz', c.s )
    end

    def test_03
      c = D.new
      c.x
      assert_equal( 'yx', c.s )
    end

    def test_04
      c = D.new
      c.z
      assert_equal( 'yxz', c.s )
    end

  end

=end
