# Test for facets/dir/traverse.

require 'facets/dir/traverse'
require 'test/unit'

# TODO Need to mockup dir for remarked out tests.

#class TC_Dir < Test::Unit::TestCase
#
#   def test_ascend_01
#     c = []
#     Dir.ascend( "this/path/up" ) do |path|
#       c << path
#     end
#     assert_equal( 'this/path/up', c[0] )
#     assert_equal( 'this/path', c[1] )
#     assert_equal( 'this', c[2] )
#   end
#
#   def test_ascend_02
#     c = []
#     Dir.ascend( "this/path/up", false ) do |path|
#       c << path
#     end
#     assert_equal( 'this/path', c[0] )
#     assert_equal( 'this', c[1] )
#   end
#
#end

