# Test for facets/file/sanitize.rb.

require 'facets/file/sanitize.rb'

require 'test/unit'

class TC_File_Sanitize < Test::Unit::TestCase

  # mock file

  class MockFile < File
    def self.open( fname, mode, &blk )
      blk.call(self)
    end
    def self.read( fname=nil )
      @mock_content.clone
    end
    def self.write( str )
      @mock_content = str
    end
    def self.<<( str )
      (@mock_content ||="") << str
    end
  end

  # TODO Write file identity tests.

  def test_sanitize_01
    assert_equal( "This_is_a_test", MockFile.sanitize('This is a test') )
  end

  def test_sanitize_02
    assert_equal( "test", MockFile.sanitize('This\is\test') )
  end

  def test_sanitize_03
    assert_equal( "test", MockFile.sanitize('This/is/test') )
  end

  def test_sanitize_04
    assert_equal( "te_____st", MockFile.sanitize('This/te#$#@!st') )
  end

  def test_sanitize_05
    assert_equal( "_.", MockFile.sanitize('.') )
  end

  def test_sanitize_06
    assert_equal( "_....", MockFile.sanitize('....') )
  end

end
