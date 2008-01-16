# TITLE:
#
#   Fileable
#
# SUMMARY:
#
#   Make File-esque classes. Fileable makes it easy to
#   create classes that can load from files.
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
#   - Thomas Sawyer
#
# TODOs:
#
#   TODO Consider cachable version of Fileable.


# = Fileable
#
# Class level mixin for loading/opening file classes.
# You will generally want to use extend with this.

module Fileable

  # When included extend DSL too.

  def self.included(base)
    base.extend DSL
  end

  # Store raw content of file.

  #attr_reader :content

  # New fileable object. By default this is called
  # by #read passing the file contents. Override it
  # if need is differnt.

  def initialize(content)
    @content = content
  end

  # Override this if reading is differnt.

  def read(file)
    self.file = file if defined?(:file=)
    initialize(File.read(file))
  end

  #
  module DSL

    # While this doesn't allpy to classes, for modules
    # it is needed to keep the DSL inheritance going.

    def included(base)
      base.extend DSL
    end

    # Override this with the name or name-glob of
    # the default file. If no default, return nil.

    def filename; nil; end

    # Load from file(s).

    def open(path=nil)
      file = file(path)
      if file
        fobj = new
        fobj.send(:read, file)
        return fobj
      end
    end

    # An initializer that can take either a File, Pathname
    # or raw data. This works much like YAML::load does.
    # Unlike +open+, +load+ requires an exact path parameter.

    def load(path_or_data)
      case path_or_data
      when File
        open(path_or_data.path)
      when Pathname
        open(path_or_data.realpath)
      else
        new(path_or_data)
      end
    end

    # Lookup file.

    def lookup(name=nil)
      file = locate(name)
      file ? open(file) : nil #raise LoadError
    end

    # Locate file (case insensitive).

    def locate(name=nil)
      name ||= filename
      raise LoadError unless name
      Dir.ascend(Dir.pwd) do |dir|
        match = File.join(dir, name)
        files = Dir.glob(match, File::FNM_CASEFOLD)
        if file = files[0]
          return file
        end
      end
      return nil
    end

    # Find file. The +path+ has to be either the
    # exact path or the directory where a
    # standard-named file resides.

    def file(path=nil)
      if !path
        raise LoadError unless filename
        path = filename
      elsif File.directory?(path)
        raise LoadError unless filename
        path = File.join(path, filename)
      end
      if file = Dir.glob(path, File::FNM_CASEFOLD)[0]
        File.expand_path(file)
      else
        raise Errno::ENOENT
      end
    end

    # Load cache. PackageInfo is multiton when loaded by file.

    def load_cache
      @load_cache ||= {}
    end
  end
end

