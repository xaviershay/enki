# TITLE:
#
#   ZipUtils
#
# SUMMARY:
#
#   Function module for compression methods.
#
# COPYRIGHT:
#
#   Copyright (c) 2006 Thomas Sawyer
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
#   - Most of this shells out. It would be best to internalize.


require 'facets/minitar'
require 'zlib'


# Function module for compression methods.
#
# Note: This used to be extensions to FileUtils.
#
module ZipUtils

  COMPRESS_FORMAT = {
    'tar.gz'  => 'tar_gzip',
    'tgz'     => 'tar_gzip',
    'tar.bz2' => 'tar_bzip',
    'zip'     => 'zip',

    '.tar.gz'  => 'tar_gzip',
    '.tgz'     => 'tar_gzip',
    '.tar.bz2' => 'tar_bzip',
    '.zip'     => 'zip'
  }

  module_function

  # Compress based on given extension.
  # Supported extensions are:
  # * tar.gz
  # * tgz
  # * tar.bz2
  # * zip

  def compress(format_extension, folder, file=nil, options={})
    format = COMPRESS_FORMAT[format_extension.to_s]
    if format
      send(format, folder, file, options)
    else
      raise ArgumentError, "unknown compression format -- #{format_extension}"
    end
  end

  # Tar Gzip

  def tar_gzip(folder, file=nil, options={})
    require 'zlib'
    # name of file to create
    file ||= File.basename(File.expand_path(folder)) + '.tar.gz'
    cmd = "tar --gzip -czf #{file} #{folder}"
    # display equivalent commandline
    if options[:verbose] or options[:dryrun]
      puts cmd
    end
    # create tar.gzip file
    unless options[:noop] or options[:dryrun]
      gzIO = Zlib::GzipWriter.new(File.open(file, 'wb'))
      Archive::Tar::Minitar.pack(folder, gzIO)
    end
    return File.expand_path(file)
  end
  alias_method :tar_z, :tar_gzip

  # Untar Gzip

  def untar_gzip(file, options={})
    require 'zlib'
    # TODO Write internalized untar_gzip function.

  end
  alias_method :untar_z, :untar_gzip

  # Tar Bzip2

  def tar_bzip2(folder, file=nil, options={})
    # name of file to create
    file ||= File.basename(File.expand_path(folder)) + '.tar.bz2'
    cmd = "tar --bzip2 -cf #{file} #{folder}"
    # display equivalent commandline
    if options[:verbose] or options[:dryrun]
      puts cmd
    end
    # create tar.bzip2 file
    unless options[:noop] or options[:dryrun]
      system cmd
    end
    return File.expand_path(file)
  end
  alias_method :tar_bzip, :tar_bzip2
  alias_method :tar_j, :tar_bzip2

  # Untar Bzip2

  def untar_bzip2(file, options={})
    cmd = "tar --bzip2 -xf #{file}"
    # display equivalent commandline
    if options[:verbose] or options[:dryrun]
      puts cmd
    end
    # untar/bzip2 file
    unless options[:noop] or options[:dryrun]
      system cmd
    end
  end
  alias_method :untar_bzip, :untar_bzip2
  alias_method :untar_j, :untar_bzip2

  # Zip

  def zip(folder, file=nil, options={})
    raise ArgumentError if folder == '.*'
    # name of file to create
    file ||= File.basename(File.expand_path(folder)) + '.zip'
    cmd = "zip -rqu #{file} #{folder}"
    # display equivalent commandline
    if options[:verbose] or options[:dryrun]
      puts cmd
    end
    # create zip file
    unless options[:noop] or options[:dryrun]
      system cmd
    end
    return File.expand_path(file)
  end

  # Unzip

  def unzip(file, options={})
    cmd = "unzip #{file}"
    # display equivalent commandline
    if options[:verbose] or options[:dryrun]
      puts cmd
    end
    # unzip file
    unless options[:noop] or options[:dryrun]
      system cmd
    end
  end
end

# Verbose version of ZipUtils.
#
# This is the same as passing :verbose flag to ZipUtils methods.

module ZipUtils::Verbose
  module_function

  def compress(format_extension, folder, file=nil, options={})
    options[:verbose] = true
    ZipUtils.tar_gzip(format_extension, folder, file, options)
  end

  def tar_gzip(folder, file=nil, options={})
    options[:verbose] = true
    ZipUtils.tar_gzip(folder, file, options)
  end

  def untar_gzip(file, options={})
    options[:verbose] = true
    ZipUtils.untar_gzip(file, options)
  end

  def tar_bzip2(folder, file=nil, options={})
    options[:verbose] = true
    ZipUtils.untar_bzip2(folder, file, options)
  end

  def untar_bzip2(file, options={})
    options[:verbose] = true
    ZipUtils.untar_bzip2(file, options)
  end

  def zip(folder, file=nil, options={})
    options[:verbose] = true
    ZipUtils.unzip(folder, file, options)
  end

  def unzip(file, options={})
    options[:verbose] = true
    ZipUtils.unzip(file, options)
  end
end

# NoWrite Version of ZipUtils.
#
# This is the same as passing :noop flag to ZipUtils methods.

module ZipUtils::NoWrite
  module_function

  def compress(format_extension, folder, file=nil, options={})
    options[:noop] = true
    ZipUtils.tar_gzip(format_extension, folder, file, options)
  end

  def tar_gzip(folder, file=nil, options={})
    options[:noop] = true
    ZipUtils.tar_gzip(folder, file, options)
  end

  def untar_gzip(file, options={})
    options[:noop] = true
    ZipUtils.untar_gzip(file, options)
  end

  def tar_bzip2(folder, file=nil, options={})
    options[:noop] = true
    ZipUtils.untar_bzip2(folder, file, options)
  end

  def untar_bzip2(file, options={})
    options[:noop] = true
    ZipUtils.untar_bzip2(file, options)
  end

  def zip(folder, file=nil, options={})
    options[:noop] = true
    ZipUtils.unzip(folder, file, options)
  end

  def unzip(file, options={})
    options[:noop] = true
    ZipUtils.unzip(file, options)
  end
end

# Dry-run verions of ZipUtils.
#
# This is the same as passing the :dryrun flag to ZipUtils.
# Which is also equivalent to passing :noop and :verbose together.

module ZipUtils::DryRun
  module_function

  def compress(format_extension, folder, file=nil, options={})
    options[:dryrun] = true
    ZipUtils.tar_gzip(format_extension, folder, file, options)
  end

  def tar_gzip(folder, file=nil, options={})
    options[:dryrun] = true
    ZipUtils.tar_gzip(folder, file, options)
  end

  def untar_gzip(file, options={})
    options[:dryrun] = true
    ZipUtils.untar_gzip(file, options)
  end

  def tar_bzip2(folder, file=nil, options={})
    options[:dryrun] = true
    ZipUtils.untar_bzip2(folder, file, options)
  end

  def untar_bzip2(file, options={})
    options[:dryrun] = true
    ZipUtils.untar_bzip2(file, options)
  end

  def zip(folder, file=nil, options={})
    options[:dryrun] = true
    ZipUtils.unzip(folder, file, options)
  end

  def unzip(file, options={})
    options[:dryrun] = true
    ZipUtils.unzip(file, options)
  end
end

#   #
#   # DryRun version of ZipUtils.
#   #
#
#   module DryRun
#     module_function
#
#     def compress( format, folder, to_file=nil )
#       send(FORMAT_TO_COMPRESS[format], folder, to_file)
#     end
#
#     # Tar Gzip
#
#     def tar_gzip( folder, to_file=nil )
#       to_file ||= File.basename(File.expand_path(folder)) + '.tar.gz'
#       puts "tar --gzip -czf #{to_file} #{folder}"
#     end
#
#     # Untar Gzip
#
#     def untar_gzip( file )
#       puts "tar --gzip -xzf #{file}"
#     end
#
#     # Tar Bzip2
#
#     def tar_bzip( folder, to_file=nil )
#       puts "tar --bzip2 -cf #{to_file} #{folder}"
#     end
#     alias_method :tar_bz2, :tar_bzip
#
#     # Untar Bzip2
#
#     def untar_bzip( file )
#       puts "tar --bzip2 -xf #{file}"
#     end
#     alias_method :untar_bz2, :untar_bzip
#
#     # Zip
#
#     def zip( folder, to_file=nil )
#       puts "zip -cf #{to_file} #{folder}"
#     end
#
#     # Unzip
#
#     def unzip( file )
#       puts "zip -xf #{file}"
#     end
#
#   end
