# TITLE:
#
#   OrderedHash
#
# DESCRIPTION:
#
#   Another name for Dictionary.
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
#
# TODO:
#
#   - Make this an alternative to Dictionary that
#     is more "slim", not having the extra sorting
#     features of dictionary.


require 'facets/dictionary'

# = OrderedHash
#
# OrderedHash is an alias for the Dictionary class

OrderedHash = Dictionary

# = AutoOrderedHash
#
# AutoOrderedHash is an alias for the AutoDictionary class

#AutoOrderedHash = AutoDictionary  # was replaced by Dictionary.auto() (or autonew?)

