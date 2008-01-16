# TITLE:
#
#   AutoArray
#
# DESCRIPTION:
#
#   An Array that automatically expands dimensions as needed.
#
# AUTHORS:
#
#   - Brian Schröder
#
# LICENSE:
#
#   Copyright (c) 2005 Brian Schröder
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.


# = AutoArray
#
# An Array that automatically expands dimensions as needed.
#
#   a  = Autoarray.new
#   a[1][2][3] = 12
#   a             #=> [nil, [nil, nil, [nil, nil, nil, 12]]]
#   a[2][3][4]    #=> []
#   a             #=> [nil, [nil, nil, [nil, nil, nil, 12]]]
#   a[1][-2][1] = "Negative"
#   a             #=> [nil, [nil, [nil, "Negative"], [nil, nil, nil, 12]]]
#
class Autoarray < Array

  def initialize(size=0, default=nil, update = nil, update_index = nil)
    super(size, default)
    @update, @update_index = update, update_index
  end

  def [](k)
    if -self.length+1 < k and k < self.length
      super(k)
    else
      Autoarray.new(0, nil, self, k)
    end
  end

  def []=(k, v)
    @update[@update_index] = self if @update and @update_index
    super
  end

end
