# TITLE:
#
#   YAML Extensions
#
# SUMMARY:
#
#   Extenstion related to YAML.
#
# AUTHORS:
#
#   - Thomas Sawyer

require 'yaml'

module Kernel
  # Convenience method for loading YAML.
  #
  def yaml(*args,&blk)
    YAML.load(*args,&blk)
  end
end

class File
  # Is a file a YAML file?
  #
  # Note this isn't perfect. At present it depends on the use
  # use of an initial document separator (eg. '---'). With
  # YAML 1.1 the %YAML delaration will be manditory, so in the
  # future this can be adapted to fit that standard.
  #
  def self.yaml?(file)
    File.open(file) do |f|
      until f.eof?
        line = f.gets
        break true if line =~ /^---/
        break false unless line =~ /^(\s*#.*?|\s*)$/
      end
    end
  end
end
