# TITLE:
#
#   BinReadable
#
# SUMMARY:
#
#   This mixin solely depends on method read(n), which must be
#   defined in the class/module where you mix in this module.
#
# COPYRIGHT:
#
#   Copyright (c) 2003 Michael Neumann
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
#   - Michael Neumann


# = BinReadable
#
# This mixin solely depends on method read(n), which must be
# defined in the class/module where you mix in this module.

module BinReadable

  #--
  # TODO Would like to get the core functionality this provides into the
  # System module and then change BinaryReader to depend on that instead.
  #++
  module ByteOrder

    Native = :Native
    BigEndian = Big = Network = :BigEndian
    LittleEndian = Little = :LittleEndian

    # examines the byte order of the underlying machine
    def byte_order
      if [0x12345678].pack("L") == "\x12\x34\x56\x78"
        BigEndian
      else
        LittleEndian
      end
    end

    alias_method :byteorder, :byte_order

    def little_endian?
      byte_order == LittleEndian
    end

    def big_endian?
      byte_order == BigEndian
    end

    alias_method :little?, :little_endian?
    alias_method :big?, :big_endian?
    alias_method :network?, :big_endian?

    module_function :byte_order, :byteorder
    module_function :little_endian?, :little?
    module_function :big_endian?, :big?, :network?

  end

  # default is native byte-order
  def byte_order
    @byte_order || ByteOrder::Native
  end

  def byte_order=(new_byteorder)
    @byte_order = new_byteorder
  end

  alias byteorder byte_order
  alias byteorder= byte_order=

  # == 8 bit

  # no byteorder for 8 bit!

  def read_word8
    ru(1, 'C')
  end

  def read_int8
    ru(1, 'c')
  end

  # == 16 bit

  # === Unsigned

  def read_word16_native
    ru(2, 'S')
  end

  def read_word16_little
    ru(2, 'v')
  end

  def read_word16_big
    ru(2, 'n')
  end

  # === Signed

  def read_int16_native
    ru(2, 's')
  end

  def read_int16_little
    # swap bytes if native=big (but we want little)
    ru_swap(2, 's', ByteOrder::Big)
  end

  def read_int16_big
    # swap bytes if native=little (but we want big)
    ru_swap(2, 's', ByteOrder::Little)
  end

  # == 32 bit

  # === Unsigned

  def read_word32_native
    ru(4, 'L')
  end

  def read_word32_little
    ru(4, 'V')
  end

  def read_word32_big
    ru(4, 'N')
  end

  # === Signed

  def read_int32_native
    ru(4, 'l')
  end

  def read_int32_little
    # swap bytes if native=big (but we want little)
    ru_swap(4, 'l', ByteOrder::Big)
  end

  def read_int32_big
    # swap bytes if native=little (but we want big)
    ru_swap(4, 'l', ByteOrder::Little)
  end

  # == Aliases

  alias read_uint8 read_word8

  # add some short-cut functions
  %w(word16 int16 word32 int32).each do |typ|
    eval %{
      alias read_#{typ}_network read_#{typ}_big
      def read_#{typ}(byte_order = nil)
        case byte_order || @byte_order
        when ByteOrder::Native  then read_#{typ}_native
        when ByteOrder::Little  then read_#{typ}_little
        when ByteOrder::Network then read_#{typ}_network
        else raise ArgumentError
        end
      end
    }
  end

  {:word16 => :uint16, :word32 => :uint32}.each do |old, new|
    ['', '_native', '_little', '_big', '_network'].each do |bo|
      eval %{
        alias read_#{new}#{bo} read_#{old}#{bo}
      }
    end
  end

  def read_cstring
    str = ""
    while (c=readn(1)) != "\0"
      str << c
    end
    str
  end

  # read exactly n characters, otherwise raise an exception.
  def readn(n)
    str = read(n)
    raise "couldn't read #{n} characters" if str.nil? or str.size != n
    str
  end

  private

  # shortcut method for readn+unpack
  def ru(size, template)
    readn(size).unpack(template).first
  end

  # same as method +ru+, but swap bytes if native byteorder == _byteorder_
  def ru_swap(size, template, byteorder)
    str = readn(size)
    str.reverse! if ByteOrder.byteorder == byteorder
    str.unpack(template).first
  end

end

# Compatability with old version.
BinaryReader = BinReadable



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

# TODO

=begin test

  require 'test/unit'

  class TC_ByteOrder < Test::Unit::TestCase

    include BinaryReader

    def test_equal
      assert_equal ByteOrder.little?, ByteOrder.little_endian?
      assert_equal ByteOrder.big?, ByteOrder.big_endian?
      assert_equal ByteOrder.network?, ByteOrder.big_endian?
      assert_equal ByteOrder.byte_order, ByteOrder.byteorder

      assert_equal ByteOrder::Big, ByteOrder::BigEndian
      assert_equal ByteOrder::Network, ByteOrder::BigEndian
      assert_equal ByteOrder::Little, ByteOrder::LittleEndian

      assert_equal ByteOrder.byte_order, ByteOrder::LittleEndian if ByteOrder.little?
      assert_equal ByteOrder.byte_order, ByteOrder::BigEndian if ByteOrder.big?
    end

    def test_uname_byteorder
      assert_equal(ByteOrder.little?, true) if `uname -m` =~ /i386/
    end

    def test_byteorder
      if ByteOrder.little?
        assert_equal "\x12\x34\x56\x78".unpack("L").first, 0x78563412
        assert_equal "\x78\x56\x34\x12".unpack("L").first, 0x12345678
        assert_equal [0x12345678].pack("L"), "\x78\x56\x34\x12"
        assert_equal [0x78563412].pack("L"), "\x12\x34\x56\x78"
      else
        assert_equal "\x12\x34\x56\x78".unpack("L").first, 0x12345678
        assert_equal "\x78\x56\x34\x12".unpack("L").first, 0x78563412
        assert_equal [0x12345678].pack("L"), "\x12\x34\x56\x78"
        assert_equal [0x78563412].pack("L"), "\x78\x56\x34\x12"
      end
    end

  end

  class TC_BinaryReader < Test::Unit::TestCase

    def test_todo
      assert(true)  # to do
    end

  end

=end
