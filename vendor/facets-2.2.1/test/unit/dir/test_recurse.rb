# Test for facets/dir/traverse.

require 'facets/dir/recurse'
require 'test/unit'

# TODO Need to mockup dir for remarked out tests.

#class TC_Dir < Test::Unit::TestCase
#
#   def test_ls_r
#     td = Dir.pwd
#     Dir.chdir $TESTDIR
#       r = ["A", "A/B","A/B/C.txt", "A/B.txt", "A.txt"].collect{ |e|
#         File.join( 'ls_r', e )
#       }
#       fs = Dir.ls_r( 'ls_r' )
#       assert_equal( r, fs, Dir.pwd  )
#     Dir.chdir td
#   end
#
#   def test_recurse
#     td = Dir.pwd
#     Dir.chdir $TESTDIR
#       r = ["A", "A/B","A/B/C.txt", "A/B.txt", "A.txt"].collect{ |e|
#         File.join( 'ls_r', e )
#       }
#       fs = Dir.recurse( 'ls_r' )
#       assert_equal( r, fs, Dir.pwd )
#     Dir.chdir td
#   end
#
#end
