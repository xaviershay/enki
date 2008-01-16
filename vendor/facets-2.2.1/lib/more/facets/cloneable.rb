# TITLE:
#
#   Clonable
#
# SUMMARY:
#
#   Standard basis for adding #dup and #clone methods to a class.
#
# COPYRIGHT:
#
#   Copyright (c) 2002 Jim Weirich
#
# LICENSE:
#
#   GNU General Public License (GPL)
#
#   Permission is hereby granted, free of charge, to any person obtaining
#   a copy of this software and associated documentation files (the
#   "Software"), to deal in the Software without restriction, including
#   without limitation the rights to use, copy, modify, merge, publish,
#   distribute, sublicense, and/or sell copies of the Software, and to
#   permit persons to whom the Software is furnished to do so, subject to
#   the following conditions:
#
#   The above copyright notice and this permission notice shall be
#   included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#   LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#   OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#   WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# HISTORY:
#
#   Cloneable was ported from Jim Weirich's Rake.
#
# AUTHORS:
#
#   - Jim Weirich
#
# TODOs:
#
#   - Method #clone should copy '<<'-methods in contrast to #dup.


# = Cloneable
#
# Standard basis for adding #dup and #clone methods to a class.

module Cloneable
  def clone
    sibling = self.class.new
    instance_variables.each do |ivar|
      value = self.instance_variable_get(ivar)
      sibling.instance_variable_set(ivar, value.dup) #rake_dup)
    end
    sibling
  end
  alias_method :dup, :clone
end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin #test
=end
