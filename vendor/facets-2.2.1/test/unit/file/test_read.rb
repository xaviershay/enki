require 'facets/file/read'

require 'test/unit'

# TODO Use real FileMock.

# class TestFileRead < Test::Unit::TestCase
#
#
#   class MockFile < ::File
#     def open( fname, mode, &blk )
#       blk.call(self)
#     end
#     def read( fname=nil )
#       @mock_content.clone
#     end
#     def write( str )
#       @mock_content = str
#     end
#     def <<( str )
#       (@mock_content ||="") << str
#     end
#   end
#
#   File = MockFile.new
#
#   def test_read_list
#     f = File.write("A\nB\nC")
#     s = File.read_list( f )
#     r = ['A','B','C']
#     assert_equal( r, s )
#   end
#
# end
