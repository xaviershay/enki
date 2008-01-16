# Test for facets/filetest/root.rb

require 'facets/filetest/root.rb'

require 'test/unit'


class TC_FileTest < Test::Unit::TestCase

  def test_root
    assert(FileTest.root?('/'))
  end

end
