# TITLE:
#
#   Daemonize
#
# SUMMARY:
#
#   Turns the current script into a daemon process
#   that detaches from the console.
#   It can be shut down with a TERM signal.
#
# COPYRIGHT:
#
#   Copyright (c) 2006 David Heinemeier Hansson
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
#   - David Heinemeier Hansson


#
module Kernel

  # Turns the current script into a daemon process
  # that detaches from the console.
  # It can be shut down with a TERM signal.

  def daemonize
    exit if fork                   # Parent exits, child continues.
    Process.setsid                 # Become session leader.
    exit if fork                   # Zap session leader. See [1].
    Dir.chdir "/"                  # Release old working directory.
    File.umask 0000                # Ensure sensible umask. Adjust as needed.
    STDIN.reopen "/dev/null"       # Free file descriptors and
    STDOUT.reopen "/dev/null", "a" # point them somewhere sensible.
    STDERR.reopen STDOUT           # STDOUT/ERR should better go to a logfile.
    trap("TERM") { exit }
  end

end
