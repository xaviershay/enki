# TITLE:
#   Virtual Shell
#
# SUMMARY:
#   Comprehensive file system access tool.
#
# COPYRIGHT:
#   Copyright (c) 2007 Thomas Sawyer
#
# LICENSE:
#   Ruby License
#
# AUTHOR:
#   - Thomas Sawyer


require 'fileutils'


# = Virtual Shell
#
#   c = VirtualShell.new
#   c.ls  #=> ['ipso.txt']

class VirtualShell

  attr_reader :root

  def initialize(*root_and_options)
    @options = Hash === root_and_options ? root_and_options.pop : {}
    @root    = root_and_options.first || "/"

    @dryrun = options[:dryrun]
    @quiet  = options[:quiet]
    #@force  = options[:force]
  end

  def dryrun? ; @dryrun ; end
  def quiet?  ; @quiet  ; end
  def verbose?  ; !@quiet  ; end
  #def force?  ; @force  ; end

  # Direct access to a directory or a file.
  def [](name)
    if File.directory?(name)
      Dir.new(name)
    elsif File.file?(name)
      File.new(name)
    else
      nil
    end
  end

  # Is a directory root?
  def root?(dir=nil)
    pth = File.expand_path(dir||work)
    return true if pth == '/'
    return true if pth =~ /^(\w:)?\/$/
    false
  end

  # Present working directory.
  def pwd; super; end

  # Directory listing
  def ls(dir, options=nil)
    Dir.entries.collect do |f|
      File.directory?(f) ? Dir.new(f) : File.new(f)
    end
  end

  # Change directory.
  #
  # cd(dir, options)
  # cd(dir, options) {|dir| .... }
  def cd(dir, options=nil, &yld)
    fu(options).cd(dir, &yld)
  end
  alias chdir cd

  # mkdir(dir, options)
  # mkdir(list, options)
  def mkdir(dir, options=nil)
    fu(options).mkdir(dir)
  end

  # mkdir_p(dir, options)
  # mkdir_p(list, options)
  def mkdir_p(dir, options=nil)
    fu(options).mkdir_p(dir)
  end

  # rmdir(dir, options)
  # rmdir(list, options)
  def rmdir(dir, options=nil)
    fu(options).rmdir(dir)
  end

  # ln(old, new, options)
  # ln(list, destdir, options)
  def ln(old, new, options=nil)
    fu(options).ln(old, new)
  end

  # ln_s(old, new, options)
  # ln_s(list, destdir, options)
  def ln_s(old, new, options=nil)
    fu(options).ln_s(old, new)
  end

  # ln_sf(src, dest, options)
  def ln_sf(src, dest, options=nil)
    fu(options).ln_sf(src, dest)
  end

  # cp(src, dest, options)
  # cp(list, dir, options)
  def cp(src, dest, options=nil)
    fu(options).cp(src, dest)
  end

  # cp_r(src, dest, options)
  # cp_r(list, dir, options)
  def cp_r(src, dest, options=nil)
    fu(options).cp_r(src, dest)
  end

  # mv(src, dest, options)
  # mv(list, dir, options)
  def mv(src, dest, options=nil)
    fu(options).mv(src, dest)
  end
  alias move mv

  # rm(list, options)
  def rm(list, options=nil)
    fu(options).rm(list)
  end

  # rm_r(list, options)
  def rm_r(list, options=nil)
    fu(options).rm_r(list)
  end

  # rm_rf(list, options)
  def rm_rf(list, options=nil)
    fu(options).rm_rf(list)
  end

  # install(src, dest, mode = <src's>, options)
  def install(src, dest, mode=src, options=nil)
    fu(options).install(src, dest, mode)
  end

  # chmod(mode, list, options)
  def chmod(mode, list, options=nil)
    fu(options).chmod(mode, list)
  end

  # chmod_R(mode, list, options)
  def chmod_R(mode, list, options=nil)
    fu(options).chmod_R(mode, list)
  end

  # chown(user, group, list, options)
  def chown(user, group, list, options=nil)
    fu(options).chown(user, group, list)
  end

  # chown_R(user, group, list, options)
  def chown_R(user, group, list, options=nil)
    fu(options).chown_R(user, group, list)
  end

  # touch(list, options)
  def touch(list, options=nil)
    fu(options).touch(list)
  end

 private

  #
  def fu(opts)
    nowrite = opts[:nowrite] || opts[:dryrun] || opts[:noop]   || dryrun?
    verbose = opts[:verbose] || opts[:dryrun] || !opts[:quiet] || verbose?

    if nowrite and verbose
      FileUtils::Dryrun
    elsif nowrite
      FileUtils::NoWrite
    elsif verbose
      FileUtils::Verbose
    else
      FileUtils
    end
  end

end
