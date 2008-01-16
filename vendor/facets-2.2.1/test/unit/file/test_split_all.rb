# Test for facets/file/topath.rb

require 'facets/file/split_all.rb'

require 'test/unit'


class TC_File_Split_All < Test::Unit::TestCase

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

  def test_split_all
    fp = "this/is/test"
    assert_equal( ['this', 'is', 'test'], MockFile.split_all(fp) )
  end

end
