# TITLE:
#
#   CompareOn
#
# SUMMARY:
#
#   Extension for making a class/module comparable.
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
# TODOs:
#
#   - TODO Maybe improve on naming.


#
class Module

  # Automatically generate sorting defintions base on attribute fields.
  #
  #   sort_on :a, :b
  #
  # _is equivalent to_
  #
  #   def <=>(o)
  #     cmp = self.a <=> o.a; return cmp unless cmp == 0
  #     cmp = self.b <=> o.b; return cmp unless cmp == 0
  #     0
  #   end
  #
  def sort_on(*fields)
    code = %{def <=>(o)\n}
    fields.each { |f|
      code << %{cmp = ( @#{f} <=> o.instance_variable_get('@#{f}') );
                return cmp unless cmp == 0\n}
    }
    code << %{0\nend; alias_method :cmp, :<=>;}
    class_eval( code )
    fields
  end

  # Should this be a standard alias?
  alias_method :compare_on, :sort_on

  # Deprecated usage
  alias_method :sort_attributes, :sort_on

  # Generates identity/key methods based on specified attributes.
  #
  #  equate_on :a, :b
  #
  # _is equivalent to_
  #
  #   def ==(o)
  #     self.a == o.a && self.b == o.b
  #   end
  #
  #   def eql?(o)
  #     self.a.eql?(o.a) && self.b.eql?(o.b)
  #   end
  #
  #   def hash()
  #     self.a.hash ^ self.b.hash
  #   end
  #
  def equate_on(*fields)
    code = ""
    code << "def ==(o) "   << fields.map {|f| "self.#{f} == o.#{f}" }.join(" && ")    << " end\n"
    code << "def eql?(o) " << fields.map {|f| "self.#{f}.eql?(o.#{f})" }.join(" && ") << " end\n"
    code << "def hash() "  << fields.map {|f| "self.#{f}.hash" }.join(" ^ ")          << " end\n"
    class_eval( code )
    fields
  end

  # Deprecated usage.
  alias_method :key_attributes, :equate_on
end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#
=begin test

  require 'test/unit'

  class TestModuleCompare < Test::Unit::TestCase

    def test_equate_on
      c = Class.new
      c.class_eval { attr_accessor :a, :b ; equate_on :a,:b }
      c1,c2 = c.new,c.new
      c1.a = 10; c1.b = 20
      c2.a = 10; c2.b = 20
      assert_equal( c1, c2 )
      c1.a = 10; c1.b = 10
      c2.a = 10; c2.b = 20
      assert_not_equal( c1, c2 )
      c1.a = 10; c1.b = 20
      c2.a = 20; c2.b = 20
      assert_not_equal( c1, c2 )
    end

    def test_sort_on
      c = Class.new
      c.class_eval {
        def initialize(a,b)
          @a=a; @b=b
        end
        sort_on :a,:b
      }
      a = [c.new(10,20),c.new(10,30)]
      assert_equal( a, a.sort )
      a = [c.new(10,30),c.new(10,20)]
      assert_equal( a.reverse, a.sort )
      a = [c.new(10,10),c.new(20,10)]
      assert_equal( a, a.sort )
      a = [c.new(20,10),c.new(10,10)]
      assert_equal( a.reverse, a.sort )
      a = [c.new(10,30),c.new(20,10)]
      assert_equal( a, a.sort )
    end

  end

=end
