# Test lib/facets/bytes.rb

require 'facets/bytes.rb'
require 'test/unit'

class TC_Numeric < Test::Unit::TestCase

  # bits

  def test_bits
    assert_equal( 8, 8.bits )
  end

  def test_kilobits
    assert_equal( 1024**1, 1.kilobit )
  end

  def test_megabits
    assert_equal( 1024**2, 1.megabit )
  end

  def test_gigabits
    assert_equal( 1024**3, 1.gigabit )
  end

  def test_terabits
    assert_equal( 1024**4, 1.terabit )
  end

  # bytes

  def test_bytes
    assert_equal( 8192, 1024.bytes )
  end

  def test_kilobytes
    assert_equal( 1024**1*8, 1.kilobyte )
  end

  def test_megabytes
    assert_equal( 1024**2*8, 1.megabyte )
  end

  def test_gigabytes
    assert_equal( 1024**3*8, 1.gigabyte )
  end

  def test_terabytes
    assert_equal( 1024**4*8, 1.terabyte )
  end

  # bits_to_s

  def test_strfbits
    assert_equal( "1.00 kb", 1024.strfbits )
    assert_equal( "1.00 mb", 1048576.strfbits )
    assert_equal( "1.00 gb", 1073741824.strfbits )
    assert_equal( "1.00 tb", 1099511627776.strfbits )
  end

  # bytes_to_s

  def test_strfbytes
    assert_equal( "1.00 KB", 1024.strfbytes )
    assert_equal( "1.00 MB", 1048576.strfbytes )
    assert_equal( "1.00 GB", 1073741824.strfbytes )
    assert_equal( "1.00 TB", 1099511627776.strfbytes )
  end

end
