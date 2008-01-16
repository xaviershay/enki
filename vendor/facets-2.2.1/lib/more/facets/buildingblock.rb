# TITLE:
#
#   BuildingBlock
#
# DESCRIPTION:
#
#   Build content programatically with Ruby and Ruby's blocks.
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
# TODO:
#
#   - Change name to BlockUp ?


# = BuildingBlock
#
# Build content programatically with Ruby and Ruby's blocks.
#
#   require 'facets'
#   require 'xmlhelper'
#
#   builder = BuildingBlock.new(XMLHelper, :element)
#
#   doc = builder.html do
#
#     head do
#       title "Test"
#     end
#
#     body do
#       i "Hello"
#       br
#       text "Test"
#       text "Hey"
#     end
#
#   end
#
# _produces_
#
#   <html><head><title>Test</title><body><i>Hello</i><br />TestHey</body></html>
#
# All calls within the block are routed via the Helper Module's constructor method
# (#element in the above example) unless they are defined by the helper module, in which
# case they are sent to the helper module directly. The results of these invocations are
# appended to the output buffer. To prevent this, prefix the method with 'call_'.
#
# Sometimes keywords can get in the way of a construction. In these cases you can
# ensure use of constructor method by calling the special #build! command. You can
# also add verbatium text to the output via the #<< operator. Some common Ruby's built-in
# methods treated as keywords:
#
#      inspect
#      instance_eval
#      respond_to?
#      singleton_method_undefined
#      initialize
#      method_missing
#      to_str
#      to_s
#
# And a few other speciality methods besides:
#
#      to_buffer
#      build!
#      <<
#
# This work was of course inspired by many great minds, and represents a concise and simple
# means of accomplishing this pattern of design, which is unique to Ruby.

class BuildingBlock

  alias __p__ p

  # NOTE: When debugging, you may want to add the 'p' entry.
  # TODO: There may be other methods that need to be in this exception list.

  ESCAPE = [
    'singleton_method_undefined',
    'respond_to?',
    'instance_eval',
    'inspect',
    'initialize'
  ] # 'to_ary', 'p' ]

  methods = instance_methods | public_instance_methods | private_instance_methods | protected_instance_methods
  methods.each{|m| undef_method m unless m=~/^__/ or ESCAPE.include?(m)}

  #

  def initialize(dslModule, constructor, output_buffer=nil)
    @buffer = output_buffer || ''
    @stack  = []

    @dsl = Class.new{
      include dslModule
    }.new

    @constructor = constructor
  end

  #

  def build!(s, *a, &b)
    s = s.to_s

    if b
      @stack << @buffer
      @buffer = ''
      instance_eval &b
      out = @buffer
      @buffer = @stack.pop
      a.unshift(out)
    end

    if s =~ /^call_/
      m = s[5..-1].to_sym
      @dsl.send(m, *a, &b).to_s
    elsif @dsl.respond_to?(s) #o =~ /^build_/
      @buffer << @dsl.send(s, *a, &b).to_s
    else
      s = s.chomp('?') if s[-1,1] == '?'
      @buffer << @dsl.send(@constructor, s, *a).to_s
    end
  end

  #

  def method_missing(s, *a, &b)
    build!(s, *a, &b)
  end

  # Return buffer

  def to_buffer()
    @buffer
  end

  # Return buffer as string.

  def to_s()   @buffer.to_s   end
  def to_str() @buffer.to_str end

  # Add directly to buffer.

  def <<(s)
    @buffer << s.to_s
  end

  # If creating and XML/HTML builder, you'll want to alias this to tag!.
  #def build!(m, *a)
  #  @buffer << @dsl.send(@constructor, m, *a).to_s
  #end

  # Could improve.

  def inspect
    r = super
    i = r.index(',')
    return r[0...i] + ">"
  end

end




=begin
    @module        = dslModule
    @constructor   = constructor
    @instance_eval = method(:instance_eval)
@module
    @method = {}

    @stack = []
    @out   = output_buffer || ''


    meths = []
    #meths.concat singleton_methods
    meths.concat public_methods
    meths.concat protected_methods
    meths.concat private_methods
    meths.each do |m|
      @method[m.to_sym] = method(m)
    end

    class << self
      escape = ESCAPE
      meths = []
      #meths.concat singleton_methods
      meths.concat public_instance_methods
      meths.concat protected_instance_methods
      meths.concat private_instance_methods
      meths.each do |m|
        undef_method(m) unless m =~ /^__/ or escape.include?(m)
      end
    end
  end
=end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin test
  require 'test/unit'

  class TestBuildingBlock < Test::Unit::TestCase

    module M
      extend self
      def m(n,*m) ; "#{n}{#{m}}"; end
      def t(n) ; "#{n}"; end
    end

    def test_01
      build = BuildingBlock.new(M, :m)

      build.html do
        head do
          title "Test"
        end

        body do
          i "Hello"
          build! :not
          t "Test"
          t "Hey"
        end
      end

      r = "html{head{title{Test}}body{i{Hello}not{}TestHey}}"

      assert_equal( r, build.to_s )
    end

  end

=end
