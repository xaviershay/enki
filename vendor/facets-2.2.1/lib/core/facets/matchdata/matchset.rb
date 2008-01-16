class MatchData

  # Returns [ pre_match, matchtree, post_match ]. (see matchtree)
  #
  #   md = /(bb)(cc(dd))(ee)/.match "XXaabbccddeeffXX"
  #   md.to_a      #=> ["XXaabbccddeeffXX", "bb", "ccdd", "dd", "ee"]
  #   md.matchset  #=> ["XXaa", [["bb"], ["cc", ["dd"]], "ee"], "ffXX"]
  #
  #   CREDIT: Trans

  def matchset
     [pre_match, matchtree, post_match]
  end

  # An alternate to #to_a which returns the matches in
  # order corresponding with the regular expression.
  #
  #   md = /(bb)(cc(dd))(ee)/.match "XXaabbccddeeffXX"
  #   md.to_a       #=> ["XXaabbccddeeffXX", "bb", "ccdd", "dd", "ee"]
  #   md.matchtree  #=> [["bb"], ["cc", ["dd"]], "ee"]
  #
  #  CREDIT: Trans

  def matchtree(index=0)
    ret=[]
    b, e=self.begin(index), self.end(index)
    while (index+=1)<=length
      if index==length || (bi=self.begin(index))>=e
        # we are finished, if something is left, then add it
        ret << string[b, e-b] if e>b
        break
      else
        if bi>=b
          ret << string[b, bi-b] if bi>b
          ret << matchtree(index)
          b=self.end(index)
        end
      end
    end
    return ret
  end

end
