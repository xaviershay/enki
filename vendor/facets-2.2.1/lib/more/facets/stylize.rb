# TITLE:
#
#   Stylize
#
# DESCRIPTION:
#
#   String derivation extensions.
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
# HISTORY:
#
#   Some of these methods were borrowed, in whole or in part, from Rails.
#   Although, not all of them are exaclty the same as their Rails' counter-parts.
#
# AUTHORS:
#
#   - Thomas Sawyer

#
class String

  module Style

    # Variation of coverting a string to camelcase. This is unlike
    # #camelcase in that it is geared toward code reflection use.
    #
    #   "this/is_a_test".camelize  #=> This::IsATest
    #
    def camelize
      #to_s.gsub(/(^|_)(.)/){$2.upcase}
      to_s.gsub(/\/(.?)/){ "::" + $1.upcase }.gsub(/(^|_)(.)/){ $2.upcase }
    end

    # Converts a string to camelcase. By default capitalization
    # occurs on whitespace and underscores. By setting the first
    # parameter to <tt>true</tt> the first character can also be
    # captizlized. The second parameter can be assigned a valid
    # Regualr Expression characeter set to determine which
    # characters to match for capitalizing subsequent parts of
    # the string.
    #
    #   "this_is a test".camelcase             #=> "thisIsATest"
    #   "this_is a test".camelcase(true)       #=> "ThisIsATest"
    #   "this_is a test".camelcase(true, ' ')  #=> "This_isATest"
    #
    def camelcase( first=false, on='_\s' )
      if first
        gsub(/(^|[#{on}]+)([A-Za-z])/){ $2.upcase }
      else
        gsub(/([#{on}]+)([A-Za-z])/){ $2.upcase }
      end
    end

    # Replaces underscores with spaces and capitalizes word.
    #
    def humanize
      self.gsub(/_/, " ").capitalize
    end

    # Removes prepend module namespace.
    #
    #   "Test::Unit".basename  #=> "Unit"
    #
    def basename
      self.to_s.gsub(/^.*::/, '')
    end
    alias_method :demodulize, :basename  # a la Rails

    # CREDIT Richard Laugesen

    # Capitalize all words (or other patterned divisions) of a string.
    #
    #   "this is a test".capitalize_all  #=> "This Is A Test"

    def title( pattern=$;, *limit )
      #gsub(/\b\w/){$&.upcase}
      split(pattern, *limit).select{ |w| w.capitalize! || w }.join(" ")
    end
    alias_method :titleize, :title
    alias_method :titlecase, :title
    alias_method :capitalize_all, :title

    # Converts a string into a valid ruby method name
    # This method is geared toward code reflection.
    #
    #
    #   "MyModule::MyClass".methodize  #=> "my_module__my_class"
    #
    # See also String#modulize, String#pathize
    #--
    # TODO Make sure methodize it is revertible
    #++
    def methodize
      to_s.gsub(/([A-Z])/, '_\1').downcase.gsub(/^_/,'').gsub(/(::|\/)_?/, '__')
    end

    # Converts a string into a valid ruby class or module name
    # This method is geared toward code reflection.
    #
    #   "my_module__my_path".modulize  #=> "MyModule::MyPath"
    #
    # See also String#methodize, String#pathize
    #
    #--
    # TODO Make sure moduleize that all scenarios return a valid ruby class name
    #++
    def modulize
      to_s.gsub(/(__|\/)(.?)/){ "::" + $2.upcase }.gsub(/(^|_)(.)/){ $2.upcase }
    end

    # Use end of string to append ordinal suffix.
    #
    def ordinalize
      Integer(self).ordinalize
    end

    alias_method :ordinal, :ordinalize

    # Converts a string into a unix path.
    # This method is geared toward code reflection.
    #
    # See : String#modulize, String#methodize
    #
    #   "MyModule::MyClass".pathize   #=> my_module/my_class
    #   "my_module__my_class".pathize #=> my_module/my_class
    #
    # TODO :
    #
    # * Make sure that all scenarios return a valid unix path
    # * Make sure it is revertible
    #
    def pathize
      to_s.gsub(/([A-Z])/, '_\1').downcase.gsub(/^_/,'').gsub(/(::|__)_?/, '/')
    end

    # Underscore string based on camelcase characteristics.
    #
    def underscore #(camel_cased_word)
      self.gsub(/([A-Z]+)([A-Z])/,'\1_\2').gsub(/([a-z])([A-Z])/,'\1_\2').downcase
    end
  end

  include Style
end


class Class

  module Style

    # Translate a class name to a suitable method name.
    #
    #   My::CoolClass.methodize => "my__cool_class"
    #
    def methodize
      name.gsub(/([A-Z]+)([A-Z])/,'\1_\2').gsub(/([a-z])([A-Z])/,'\1_\2').gsub('::','__').downcase
    end

    # Converts a class name to a unix path
    #
    #   My::CoolClass.pathize  #=> "/my/cool_class"
    #
    def pathize
      '/' + name.gsub(/([A-Z]+)([A-Z])/,'\1_\2').gsub(/([a-z])([A-Z])/,'\1_\2').gsub('::','/').downcase
    end

  end

  include Style
end


class Integer

  module Style

    def ordinalize
      if [11,12,13].include?(self % 100)
        "#{self}th"
      else
        case (self % 10)
        when 1
          "#{self}st"
        when 2
          "#{self}nd"
        when 3
          "#{self}rd"
        else
          "#{self}th"
        end
      end
    end

    alias_method :ordinal, :ordinalize
  end

  include Style
end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#
=begin test

  require 'test/unit'

  class TestInflect < Test::Unit::TestCase

    def test_basename_01
      assert_equal( "Unit", "Test::Unit".basename )
    end

    def test_basename_02
      a =  "Down::Bottom"
      assert_raises( ArgumentError ) { a.basename(1) }
    end

    def test_basename_03
      a =  "Down::Bottom"
      assert_equal( "Bottom", a.basename )
    end

    def test_basename_04
      b =  "Further::Down::Bottom"
      assert_equal( "Bottom", b.basename )
    end

    def test_camelize
      assert_equal( 'ThisIsIt', 'this_is_it'.camelize )
    end

    def test_camelcase
      assert_equal( "abcXyz", "abc_xyz".camelcase )
      assert_equal( "abcXyz", "abc xyz".camelcase )
      assert_equal( "abcXyz", "abc  xyz".camelcase )
      assert_equal( "abcXyz", "abc\txyz".camelcase )
      assert_equal( "abcXyz", "abc\nxyz".camelcase )
      assert_equal( "abcXyz", "abc____xyz".camelcase )
    end

    def test_camelcase_true
      assert_equal( "AbcXyz", "abc_xyz".camelcase(true) )
      assert_equal( "AbcXyz", "abc xyz".camelcase(true) )
      assert_equal( "AbcXyz", "abc  xyz".camelcase(true) )
      assert_equal( "AbcXyz", "abc\txyz".camelcase(true) )
      assert_equal( "AbcXyz", "abc\nxyz".camelcase(true) )
    end

    def test_humanize
      assert_equal( 'This is it', 'this_is_it'.humanize )
    end

    def test_title
      r = "try this out".title
      x = "Try This Out"
      assert_equal(x,r)
    end

    def test_demodulize_01
      a =  "Down::Bottom"
      assert_raises( ArgumentError ) { a.demodulize(1) }
    end

    def test_demodulize_02
      a =  "Down::Bottom"
      assert_equal( "Bottom", a.demodulize )
    end

    def test_demodulize_03
      b =  "Further::Down::Bottom"
      assert_equal( "Bottom", b.demodulize )
    end

    def test_demodulize_01
      a =  "Down::Bottom"
      assert_raises( ArgumentError ) { a.demodulize(1) }
    end

    def test_demodulize_02
      a =  "Down::Bottom"
      assert_equal( "Bottom", a.demodulize )
    end

    def test_demodulize_03
      b =  "Further::Down::Bottom"
      assert_equal( "Bottom", b.demodulize )
    end

    def test_methodize
      assert_equal( 'hello_world', 'HelloWorld'.methodize )
      assert_equal( '__unix_path', '/unix_path'.methodize )
    end

    def test_modulize
      assert_equal( 'MyModule::MyClass',   'my_module__my_class'.modulize   )
      assert_equal( '::MyModule::MyClass', '__my_module__my_class'.modulize )
      assert_equal( 'MyModule::MyClass',   'my_module/my_class'.modulize    )
      assert_equal( '::MyModule::MyClass', '/my_module/my_class'.modulize   )
    end

    def test_pathize
      assert_equal( 'my_module/my_class',   'MyModule::MyClass'.pathize )
      assert_equal( 'u_r_i',                'URI'.pathize )
      assert_equal( '/my_class',            '::MyClass'.pathize )
      assert_equal( '/my_module/my_class/', '/my_module/my_class/'.pathize )
    end

  end


  class TestClassInflect < Test::Unit::TestCase

    def test_method_name
      assert_equal( Test::Unit::TestCase.methodize, 'test__unit__test_case' )
    end

    def test_method_name
      assert_equal( Test::Unit::TestCase.pathize, '/test/unit/test_case' )
    end

  end

  class TestIntegerInflect < Test::Unit::TestCase

    def test_ordinalize
      assert_equal( '1st', '1'.ordinalize )
      assert_equal( '2nd', '2'.ordinalize )
      assert_equal( '3rd', '3'.ordinalize )
      assert_equal( '4th', '4'.ordinalize )
    end

    def test_ordinal
      assert_equal( '1st', 1.ordinal )
      assert_equal( '2nd', 2.ordinal )
      assert_equal( '3rd', 3.ordinal )
      assert_equal( '4th', 4.ordinal )
    end

  end

=end
