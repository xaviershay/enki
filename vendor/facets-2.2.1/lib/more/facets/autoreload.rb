# TITLE:
#
#   Autoreload
#
# SUMMARY:
#
#   Automatically reload libraries.
#
# COPYRIGHT:
#
#   Copyright (c) 2003 Michael Neumann
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
#   - Michael Neumann
#   - George Moschovitis

#
module Kernel

  # Autoreload feature files.
  #
  # Automatically reload, at regular intervals, any previously loaded features,
  # and/or other files not already loaded, if they have been modified since the last
  # interval check. A numeric parameter sets the reload interval in seconds
  # and the file parameter can either be a glob string or an array
  # of file paths. If a glob string, it is expanded only once on the initial
  # method call. Supplying a boolean parameter of 'false' will force autreload to
  # skip previously loaded features and only reload the specified files.
  # Also keeps a "dirty" flag.

  def autoreload( *args )

    check_interval=10
    include_features = true
    files = nil

    args.each do |arg|
      case arg
      when Numeric
        check_interval = arg
      when String
        files = Dir.glob( arg )
      when Array
        files = arg
      when TrueClass, FalseClass
        include_features = arg
      end
    end

    file_mtime = {}

    Thread.new(Time.now) do |start_time|
      loop do
        sleep check_interval

        if include_features
          feature_files = $LOADED_FEATURES.collect { |feature|
            $LOAD_PATH.each { |lp| file = File.join(lp, feature) }
          }.flatten

          feature_files.each { |file|
            if File.exists?(file) and (mtime = File.stat(file).mtime) > (file_mtime[file] || start_time)
              $autoreload_dirty = true
              file_mtime[file] = mtime
              STDERR.puts "File '#{ file }' reloaded"
              begin
                load(file)
              rescue Exception => e
                STDERR.puts e.inspect
              end
            end
          }
        end

        if files
          files.each do |file|
            if File.exists?(file) and (mtime = File.stat(file).mtime) > (file_mtime[file] || start_time)
              $autoreload_dirty = true
              file_mtime[file] = mtime
              STDERR.puts "File '#{ file }' changed"
            end
          end
        end

      end
    end

  end

  # Same as #autoreload, but does not include previously loaded features.
  # This is equivalent to as adding a 'false' parameter to #autoreload.
  #
  def autoreload_files( *args )
    autoreload( false, *args )
  end

  # deprecate
  def autoreload_glob(*args)
    warn "autoreload_glob will be deprecated. Use autoreload_files instead."
    autoreload_files(*args)
  end

end

#--
#   # OLD VERSION
#   def autoreload(check_interval=10)
#     Thread.new(Time.now) { |start_time|
#       file_mtime = {}
#       loop {
#         sleep check_interval
#         $LOADED_FEATURES.each { |feature|
#           $LOAD_PATH.each { |lp|
#             file = File.join(lp, feature)
#             if (File.exists?(file) and
#               File.stat(file).mtime > (file_mtime[file] || start_time))
#               file_mtime[file] = File.stat(file).mtime
#               STDERR.puts "reload #{ file }"
#               begin
#                 load(file)
#               rescue Exception => e
#                 STDERR.puts e.inspect
#               end
#             end
#           }
#         }
#       }
#     }
#   end
#++

#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#
# TODO
