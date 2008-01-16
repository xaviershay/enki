# TITLE:
#
#   Capsule
#
# SUMMARY:
#
#   A Capsule is subclass of Module. It encapsulates an extenal script
#   as a funcitons module.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer, Joel VanderWerf
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
#   - Joel VanderWerf
#   - Thomas Sawyer
#
# TODOs:
#
#   - The name of this is rather weak. Think of a better one.

#require 'rbconfig'

# A Capsule is subclass of Module. It encapsulates an extenal script
# as a funcitons module.
#
# A module which is an instance of the Capsule class encapsulates in its scope
# the top-level methods, top-level constants, and instance variables defined in
# a ruby script file (and its subfiles) loaded by a ruby program. This allows
# use of script files to define objects that can be loaded into a program in
# much the same way that objects can be loaded from YAML or Marshal files.
#
# See intro.txt[link:files/intro_txt.html] for an overview.

class Capsule < Module

  #DLEXT = Config::CONFIG['DLEXT']

  # The script file with which the Import was instantiated.
  attr_reader :main_file

  # The directory in which main_file is located, and relative to which
  # #load searches for files before falling back to Kernel#load.
  #attr_reader :dir

  # An array of paths to search for scripts. This has the same
  # semantics as <tt>$:</tt>, alias <tt>$LOAD_PATH</tt>, excpet
  # that it is local to this script. The path of the current
  # script is added automatically (equivalent to '.')
  attr_reader :load_path

  # A hash that maps <tt>filename=>true</tt> for each file that has been
  # required locally by the script. This has the same semantics as <tt>$"</tt>,
  # alias <tt>$LOADED_FEATURES</tt>, except that it is local to this script.
  attr_reader :loaded_features

  class << self
    # As with #new but will search Ruby's $LOAD_PATH first.
    #--
    # Will also try .rb, .so, .dll, et al extensions, like require does.
    #++
    def load(main_file, options=nil, &block)
      file = nil
      $LOAD_PATH.each do |path|
        break if file = File.file?(File.join(path, main_file))
        #break if file = Dir.glob(File.join(path, main_file)+'{,.rb,.'+DLEXT+'}')[0]
      end
      new(file || main_file, options=nil, &block)
    end
  end

  # Creates new Capsule, and loads _main_file_ in the scope of the script. If a
  # block is given, the script is passed to it before loading from the file, and
  # constants can be defined as inputs to the script.

  def initialize(main_file, options=nil, &block)
    extend self

    options ||= {}

    @main_file       = File.expand_path(main_file)
    @load_path       = options[:load_path] || []
    #@load_path |= [File.dirname(@main_file)]  # before or after?
    @loaded_features = options[:loaded_features] || {}

    # TODO In order to load/require at the instance level.
    # This needs to be in a separate namespace however
    # b/c it can interfere with what is expected.
    #[ :require, :load ].each{ |meth|
    #  m = method(meth)
    #  define_method(meth) do |*args| m.call(*args) end
    #}

    module_eval(&block) if block
    extend self

    load_in_module(main_file)
  end

  # Lookup feature in load path.

  def load_path_lookup(feature)
    paths = File.join('{' + @load_path.join(',') + '}', feature + '{,.rb,.rbs}')
    files = Dir.glob(paths)
    match = files.find{ |f| ! @loaded_features.include?(f) }
    return match
  end

  # Loads _file_ into the capsule. Searches relative to the local dir, that is,
  # the dir of the file given in the original call to
  # <tt>Capsule.load(file)</tt>, loads the file, if found, into this Capsule's
  # scope, and returns true. If the file is not found, falls back to
  # <tt>Kernel.load</tt>, which searches on <tt>$LOAD_PATH</tt>, loads the file,
  # if found, into global scope, and returns true. Otherwise, raises
  # <tt>LoadError</tt>.
  #
  # The _wrap_ argument is passed to <tt>Kernel.load</tt> in the fallback case,
  # when the file is not found locally.
  #
  # Typically called from within the main file to load additional sub files, or
  # from those sub files.
  #
  #--
  # TODO Need to add load_path lookup.
  #++

  def load(file, wrap = false)
    load_in_module(File.join(@dir, file))
    true
  rescue MissingFile
    super
  end

  # Analogous to <tt>Kernel#require</tt>. First tries the local dir, then falls
  # back to <tt>Kernel#require</tt>. Will load a given _feature_ only once.
  #
  # Note that extensions (*.so, *.dll) can be required in the global scope, as
  # usual, but not in the local scope. (This is not much of a limitation in
  # practice--you wouldn't want to load an extension more than once.) This
  # implementation falls back to <tt>Kernel#require</tt> when the argument is an
  # extension or is not found locally.
  #
  #--
  # This was using load_in_module rather than include_script. Maybe is still should
  # and one should have to call include_script instead? Think about this.
  #++

  def require(feature)
    file = load_path_lookup(feature)
    return super unless file
    begin
      @loaded_features[file] = true
      load_in_module(file)
    rescue MissingFile
      @loaded_features[file] = false
      super
    end
  end

  # Raised by #load_in_module, caught by #load and #require.
  class MissingFile < LoadError; end

  # Loads _file_ in this module's context. Note that <tt>\_\_FILE\_\_</tt> and
  # <tt>\_\_LINE\_\_</tt> work correctly in _file_.
  # Called by #load and #require; not normally called directly.

  def load_in_module(file)
    module_eval(IO.read(file), File.expand_path(file))
  rescue Errno::ENOENT => e
    if /#{file}$/ =~ e.message
      raise MissingFile, e.message
    else
      raise
    end
  end

  def include_script(file)
    include self.class.new(file, :load_path=>load_path, :loaded_features=>loaded_features)
  rescue Errno::ENOENT => e
    if /#{file}$/ =~ e.message
      raise MissingFile, e.message
    else
      raise
    end
  end

  #
  def include(*mods)
    super
    extend self
  end

  def to_s # :nodoc:
    "#<#{self.class}:#{main_file}>"
  end

end

# TODO Is autoimport bets name for this?

class Module

  const_missing_definition_for_autoimport = lambda do
    #$autoimport_activated = true
    alias const_missing_before_autoimport const_missing

    def const_missing(sym) # :nodoc:
      filename = @autoimport && @autoimport[sym]
      if filename
        mod = Import.load(filename)
        const_set sym, mod
      else
        const_missing_before_autoimport(sym)
      end
    end
  end

  # When the constant named by symbol +mod+ is referenced, loads the script
  # in filename using Capsule.load and defines the constant to be equal to the
  # resulting Capsule module.
  #
  # Use like Module#autoload--however, the underlying opertation is #load rather
  # than #require, because scripts, unlike libraries, can be loaded more than
  # once. See examples/autoscript-example.rb

  define_method(:autoimport) do |mod, file|
    if @autoimport.empty? #unless $autoimport_activated
      const_missing_definition_for_autoimport.call
    end
    (@autoimport ||= {})[mod] = file
  end
end


module Kernel

  # Calls Object.autoimport
  def autoimport(mod, file)
    Object.autoimport(mod, file)
  end

end
