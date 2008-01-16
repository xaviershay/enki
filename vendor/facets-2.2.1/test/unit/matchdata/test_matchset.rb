# Test for lib/facets/matchdata/matchset

require 'facets/matchdata/matchset.rb'

require 'test/unit'

class Test_MatchData_Matchset < Test::Unit::TestCase

  def test_matchtree_01
    md = /(bb)(cc(dd))(ee)/.match "XXaabbccddeeffXX"
    assert_equal( [["bb"], ["cc", ["dd"]], ["ee"]] , md.matchtree )
  end

  def test_matchtree_02
    md = /(bb)c(c(dd))(ee)/.match "XXaabbccddeeffXX"
    assert_equal( [["bb"], "c", ["c", ["dd"]], ["ee"]] , md.matchtree )
  end

  def test_matchset
    md = /(bb)(cc(dd))(ee)/.match "XXaabbccddeeffXX"
    assert_equal( ["XXaa", [["bb"], ["cc", ["dd"]], ["ee"]], "ffXX"] , md.matchset )
  end

end
