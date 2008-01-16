class MatchData

  # Return the primary match string. This is equivalent to +md[0]+.
  #
  #   md = /123/.match "123456"
  #   md.match  #=> "123"
  #
  #   TODO: Is MatchData#match really worth having? It's kind of confusing w/ Regexp#match.
  #
  #   CREDIT: Trans

  def match
    self[0]
  end

end
