# TITLE:
#
#   Shellwords Extended
#
# DESCRIPTION:
#
#   Adds extensions to Shellwords, namely #escape.
#
# COPYRIGHT:
#
#   Copyright (c) 2007 Thomas Sawyer
#
# LICENSE:
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
# AUTHORS:
#
#   - Thomas Sawuer


require 'shellwords'


module Shellwords

  module_function

  # Escape special characters used in most
  # unix shells to use it, eg. with system().

  def escape(cmdline)
    cmdline.gsub(/([\\\t\| &`<>)('"])/) { |s| '\\' << s }
  end

end
