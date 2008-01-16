# TITLE:
#
#   OpenCollection
#
# DESCRIPTION:
#
#   A mapping OpenObject.
#
# AUTHOR:
#
#   - Thomas Sawyer
#
# LICENSE:
#
#   Copyright (c) 2005 Thomas Sawyer, George Moschovitis
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.


require 'facets/openobject'

# = OpenCollection
#
class OpenCollection

  def initialize(*hash)
    @opens = hash.map do |h|
      OpenObject.new(h)
    end
  end

  def method_missing(sym)
    @opens.map do |o|
      o.send(sym)
    end
  end

end

