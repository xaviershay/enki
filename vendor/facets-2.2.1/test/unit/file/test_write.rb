# Test for facets/file/write.rb

# TODO Needs a file mock.

require 'facets/file/write.rb'
require 'test/unit'
require 'tempfile'

class TC_FileWrite < Test::Unit::TestCase

  def setup
    tmp_dir = Dir::tmpdir # ENV["TMP"] || ENV["TEMP"] || "/tmp"
    raise "Can't find temporary directory" unless File.directory?(tmp_dir)
    @path = File.join(tmp_dir, "ruby_io_test")
  end

  # Test File.write
  def test_file_write
    data_in = "Test data\n"
    nbytes = File.write(@path, data_in)
    data_out = File.read(@path)          # This is standard class method.
    assert_equal(data_in, data_out)
    assert_equal(data_out.size, nbytes)
  end

  # Test File.writelines
  def test_file_writelines
    data_in = %w[one two three four five]
    File.writelines(@path, data_in)
    data_out = File.readlines(@path)     # This is standard class method.
    assert_equal(data_in, data_out.map { |l| l.chomp })
  end

end


# TODO This isn't right, and I'm concerned about acidentally writing a real file.

# class TestFileWrite < Test::Unit::TestCase
#
#   class MockFile < ::File
#     def open( fname, mode, &blk )
#       blk.call(self)
#     end
#     def ead( fname=nil )
#       @mrock_content.clone
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
#   def test_create
#     f = "not a real file"
#     t = 'This is a test'
#     File.create( f, t )
#     s = File.read( f )
#     assert_equal( t, s )
#   end
#
#   def test_rewrite
#     f = "not a real file"
#     t = 'This is a test'
#     File.write( t )
#     File.rewrite(f) { |s| s.reverse! }
#     s = File.read(f)
#     assert_equal( t.reverse, s )
#   end
#
# end

