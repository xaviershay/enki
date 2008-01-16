# = downloader.rb
#
# == Copyright (c) 2005 Thomas Sawyer
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
# == Authors and Contributors
#
# * Thomas Sawyer
#
# == Developer Noters
#
#   TODO This should be divied into two classes. The main Downloader
#        should be independent of any interface. The second Console::Downloader
#        using the first but with a console interface.

# Author::    Thomas Sawyer
# Copyright:: Copyright (c) 2006 Thomas Sawyer
# License::   Ruby License

require 'digest/md5'
require 'open-uri'

require 'facets/string/bracket' # for unbracket
require 'facets/progressbar'

# = Downloader
#
# Tool module for downloading files and extracting
# archive files. Currently this is console-based
# but in the future will have SOC for any interface.

class Downloader

  #class DownloadError < StandardError #:nodoc:
  #end

  class Checksum < StandardError #:nodoc:
  end

  class Mirror #:nodoc:
    def initialize( url, region=nil )
      @url = url
      @region = region
      @interface = nil
    end
    attr_accessor :url, :region
  end

  # delegate to an interface (under development)

  def interface ; @interface; end
  def interface=(iface)
    @interface = iface
  end

  def initialize( destination, mirrors=nil, region=nil, &config )
    @destination = destination
    @mirrors = []
    add_mirrors( mirrors ) if mirrors
    @region = (region || 'US').to_s
    config.call(self) if config
  end

  attr_accessor :destination, :region

  def add_mirror( url, region=nil )
    @mirrors << Mirror.new( url, region )
  end

  def add_mirrors( mirrors )
    mirrors.each { |mirror|
      case mirror
      when String
        url, rgn = *mirror.strip.split(' ')
        add_mirror( url, rgn.unbracket )
      when Array
        add_mirror( *mirror )
      when Hash
        add_mirror( mirror[:url], mirror[:region] )
      when Mirror
        @mirrors << mirror
      else
        raise "unrecogized mirror definition #{mirror.inspect}"
      end
    }
  end

  def mirrors
    @mirrors.sort{ |a,b| a.region == region ? 1 : ( b.region == region ? -1 : 0 ) }
  end

  # fetch

  def fetch( file, checksum=0, est_size=0, force=false )
    urls = mirrors.collect { |m| "#{m.url.chomp('/')}/#{file}" }
    urls = prioritize_urls( urls )
    filepath = "#{destination.chomp('/')}/#{file}"
    monitored_download( urls, filepath, checksum, est_size, force )
  end

#   def download_verbose
#     @download_verbose ||= $VERBOSE
#     true
#   end
#
#   def download_verbose=(x)
#     @download_verbose = x ? true : false
#   end

  # regional_urls - array of arrays of [ url, region, md5, expected_size ]
  # local_region - region of the user's system
  # to_dir - where to store downloaded file (full path)
  # force - download even if file already exists locally

  def monitored_download( urls, filepath, checksum, est_size=0, force=false )

    checksum = checksum.to_s.strip
    est_size = nil if est_size == 0

    success=nil

    # source file exists and passes checksum then we need not fetch
    #file_path = File.join(to_dir,File.basename(url[0]))
    if File.exists?(filepath)
      if compute_checksum(filepath) == checksum and ! force
        interface.report("File has already been fetched and passes checksum.")
        success = filepath
      else
        File.delete(filepath)
      end
    end

    unless success
      # download
      urls.each do |url|
        begin
          #file_path = File.join(to_dir,File.basename(url[0]))
          #file_checksum = url[2].to_s.strip
          #file_size = url[3].to_i
          success = self.download( url, filepath, checksum, est_size )
          break if success
        rescue
          next
        end
      end
    end

    return success
  end

  # In the future we may test each connection for fastest download

  def prioritize_urls( urls )
    urls
    # put local region first
    #prioritized_urls = regional_urls.find_all { |a| a[1] == local_region }
    #prioritized_urls.concat regional_urls.find_all { |a| a[1] != local_region }
    #return prioritized_urls
  end

  # currently can only download a single compressed file
  # does not handle downloading an uncompressed directory tree (should it? doubt it)
  #
  # currently this displays progress to STDOUT; either their should
  # be a way to activate/deactivate or preferably use ducktype singletons
  # (more on that later, see google://_whytheluckystiff if interested)
  # of course I prefer chain messaging but matz said no :(

  def download( url, filepath, checksum='', est_size=nil )

    checksum = checksum.to_s.strip
    est_size = nil if est_size == 0

    download_complete = nil

    if interface
      interface.preparing_to_download( File.basename( filepath ), url, est_size )
    end

    progress_total = est_size ? est_size : 100000000  # pretend 100MB if no size
    pbar = Console::ProgressBar.new( "Status", progress_total, STDOUT )
    pbar.bar_mark = "="
    pbar.format = "%-6s %3d%% %s %s"
    pbar.file_transfer_mode if est_size

    progress_proc = proc { |posit| pbar.set(posit) }

    STDOUT.sync = true
    begin
      local_file = File.open( filepath, 'wb' )
      remote_file = open( url, :progress_proc => progress_proc )
      local_file << remote_file.read
    rescue
      pbar.halt
      download_complete = nil
      raise
    else
      pbar.finish
      download_complete = filepath
    ensure
      remote_file.close unless remote_file.nil?
      local_file.close unless local_file.nil?
      STDOUT.sync = false
    end

    unless checksum.empty?
      raise ChecksumError if compute_checksum(filepath) != checksum
    end

    if interface
      if checksum.empty?
        interface.lacks_checksum( compute_checksum(filepath), :md5 )
      end
      unless est_size
        interface.lacks_size( File.size(filepath) )
      end
    end

    if download_complete
      if interface
        interface.downloaded( filepath )
      end
    end

    return download_complete
  end

  # compute_checksum

  def compute_checksum( local_path )
    if File.exists?( local_path )
      File.open( local_path ) do |local_file|
        return Digest::MD5.new( local_file.read ).hexdigest
      end
    end
  end

  # extract

  def extract( local_path )
    success = false
    local_dir = File.dirname(local_path)
    local_file = File.basename(local_path)
    current_dir = Dir.getwd
    begin
      Dir.chdir(local_dir)
      case local_file
        when /.*gz$/
          system "tar -xzf #{local_file}"
        when /.*bz2$/
          system "tar -xjf #{local_file}"
        when /.zip$/
          system "unzip #{local_file}"
        else
          success = false
      end
    rescue
      success = false
    else
      success = true
    ensure
      Dir.chdir(current_dir)
    end
    if interface
      interface.extracted( local_path)
    end
    return success
  end

end

