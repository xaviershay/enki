# Test for facets/binreadable.rb

require 'facets/binreadable.rb'
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
