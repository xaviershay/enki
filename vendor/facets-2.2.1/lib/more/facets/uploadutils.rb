# TITLE:
#
#   UploadUtils
#
# SUMMARY:
#
#   Upload files to host.
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
#   - Needs general improvements.
#
#   - Reduce shelling-out.
#
#   - Incorporate password into scp and ftp ?
#
#   - rsync needs --delete option

require 'openssl'
require 'shellwords'
require 'tmpdir'
require 'facets/openobject'

# = UploadUtils
#
# Upload files to host. These means of uploading are current
# supported: ftp, sftp, scp and rsync.
#
#     user       Username for host.
#     host       Host server's domain name.
#     root       Document root path on host.
#     copy       Directory of files to publish, or
#                Files to publish using from and to.
#
#     dryrun     If true only pretend to upload.
#     quiet      Supress all output.
#     verbose    Provide extra details.
#
# The copy parameter allows you to simply specify a file
# or directory which will be published to host's document
# root location.
#
# If you need more control over which files to publish
# where, you can use the copy parameter instead. Provide
# an array of pattern strings in the form of "{from} {to}".
# If the desitination is the host's document root you do
# not need to specify the {to} part. For example:
#
#     copy = [ 'web/*', 'doc/api/* doc/api' ]
#
# The first copies the files under your project's web directory
# to the host's document root. The second copies your projects
# doc/api files to the doc/api location on the host.
#
# The internal template used for the outbound destination
# is 'username@host:root/'.

module UploadUtils

  module_function

  #
  # Upload via given protocol.
  #

  def upload( protocol, opts )
    send(protocol.to_s.downcase,opts)
  end

  #
  # Use ftp to upload files.
  #

  def ftp( keys )
    keys = upload_parameters(keys)

    # set transfer rules
    if keys.stage
      trans = stage_transfer(keys.stage)
    else
      files(keys.dir, keys.copy).each do |from|
        trans << [from,from]
      end
    end

    # append location of publication dir to from
    dir = keys.dir
    trans.collect!{ |from,to| [File.join(dir,from), to] }

    if keys.dryrun
      puts "ftp open #{keys.user}@#{keys.host}:#{keys.root}/"
      keys.trans.each do |f, t|
        puts "ftp put #{f} #{t}"
      end
    else
      require 'net/ftp'
      Net::FTP.open(keys.host) do |ftp|
        ftp.login(keys.user) #password?
        ftp.chdir(keys.root)
        keys.trans.each do |f, t|
          puts "ftp #{f} #{t}" unless keys.quiet
          ftp.putbinaryfile( f, t, 1024 )
        end
      end
    end
  end

  #
  # Use sftp to upload files.
  #

  def sftp( keys )
    keys = upload_parameters(keys)

    # set transfer rules
    if keys.stage
      trans = stage_transfer(keys.stage)
    else
      files(keys.dir, keys.copy).each do |from|
        trans << [from,from]
      end
    end

    # append location of publication dir to from
    dir = keys.dir
    trans.collect!{ |from,to| [File.join(dir,from), to] }

    if keys.dryrun
      puts "sftp open #{keys.user}@#{keys.host}:#{keys.root}/"
      keys.trans.each do |f,t|
        puts "sftp put #{f} #{t}"
      end
    else
      require 'net/sftp'
      Net::SFTP.start(keys.host, keys.user, keys.pass) do |sftp|
        #sftp.login( user )
        sftp.chdir(keys.root)
        keys.trans.each do |f,t|
          puts "sftp #{f} #{t}" unless keys.quiet
          sftp.put_file(f,t) #, 1024 )
        end
      end
    end
  end

  #
  # Use rsync to upload files.
  #

  def rsync( keys )
    keys = upload_parameters(keys)

    flags = []
    flags << "-n" if keys.dryrun
    flags << "-q" if keys.quiet
    flags << "-v" if keys.verbose
    flags << "--progress" unless keys.quiet
    flags = flags.join(' ').strip
    flags = ' ' + flags unless flags.empty?

    manfile = 'Publish.txt'

    if keys.stage
      dir = stage_linkdir(keys.dir, keys.stage)
      Dir.chdir(dir) do
        cpy = files(keys.copy)
      end
      manifest = File.join(dir,manfile)
      cmd = %{rsync#{flags} -L -arz --files-from='#{manifest}' #{dir} #{keys.user}@#{keys.host}:/#{keys.root}}
    else
      dir = keys.dir
      cpy = files(dir, keys.copy)
      manifest = File.join(dir,manfile)
      cmd = %{rsync#{flags} -arz --files-from='#{manifest}' #{dir} #{keys.user}@#{keys.host}:/#{keys.root}}
    end

    #Dir.chdir(keys.dir) do
      begin
        File.open(manifest, 'w'){ |f| f << cpy.join("\n") }
        ENV['RSYNC_PASSWORD'] = keys.pass if keys.pass
        puts cmd unless keys.quiet
        system cmd
      ensure
        ENV.delete('RSYNC_PASSWORD') if keys.pass
      end
    #end

  end

  # private (can't do b/c of module_function)

  # parse publishing options.

  def upload_parameters( keys )
    keys = OpenObject.new(keys)

    keys.copy = keys.copy || '**/*'
    keys.host = keys.host || keys.domain
    keys.user = keys.user || keys.username
    keys.root = keys.root || '/'
    #keys.pass = keys.pass || keys.password

    # validate
    raise ArgumentError, "missing publish parameter -- dir" unless keys.dir
    raise ArgumentError, "missing publish parameter -- host" unless keys.host
    raise ArgumentError, "missing publish parameter -- user" unless keys.user
    #raise ArgumentError, "missing publish parameter -- copy" unless keys.copy
    #raise ArgumentError, "missing publish parameter -- root" unless keys.root

    keys.root = '' if keys.root.nil?
    keys.root.sub!(/^\//,'')

    if String===keys.copy and File.directory?(keys.copy)
      copy = File.join(keys.copy, '*')
    end
    keys.copy = [keys.copy].flatten.compact

#     trans = []
#     keys.copy.each do |from|
#       #from, to = *Shellwords.shellwords(c)
#       #to = from if to.nil?
#       #to = to[1..-1] if to[0,1] == '/'
#       from.sub('*','**/*') unless from =~ /\*\*/
#       files = Dir.glob(from)
#       files.each do |f|
#         #t = File.join(to,File.basename(f))
#         #t = t[1..-1] if t[0,1] == '/'
#         trans << [f,f]
#       end
#     end
#     keys.trans = trans

    return keys
  end

  # Put together the list of files to copy.

  def files( dir, copy )
    Dir.chdir(dir) do
      del, add = copy.partition{ |f| /^[-]/ =~ f }

      # remove - and + prefixes
      del.collect!{ |f| f.sub(/^[-]/,'') }
      add.collect!{ |f| f.sub(/^[+]/,'') }

      #del.concat(must_exclude)

      files = []
      add.each{ |g| files += Dir.multiglob(g) }
      del.each{ |g| files -= Dir.multiglob(g) }

      files.collect!{ |f| f.sub(/^\//,'') }

      return files
    end
  end

  # Combine three part stage list into a two part from->to list.
  #
  # Using the stage list of three space separated fields.
  #
  #   fromdir file todir
  #
  # This is used to generate a from -> to list of the form:
  #
  #  fromdir/file todir/file
  #

  def stage_transfer( list )
    trans = []
    list.each do |line|
      trans << Shellwords.shellwords(line)
    end

    trans.collect! do |from, base, to|
      file = File.join(from,base)
      to = File.join(to,base)
      [from, to]
    end
  end

  # When using stage options this will create temporary linked location.

  def stage_linkdir( dir, list )
    folder = File.join(Dir.tmpdir, 'ratchets', 'project', object_id.abs.to_s)
    FileUtils.mkdir_p(folder)

    Dir.chdir(dir) do
      stage_transfer(list).each do |file, to|
        link = File.join(folder,to)
        FileUtils.ln_s(link,file)
      end
    end

    return folder
  end


=begin


  #--
  # SHELLS OUT! Need net/scp library to fix.
  #++

  # Use scp to upload files.

  def scp( keys )
    keys = upload_parameters(keys)

    flags = []
    flags << "-v" if keys.verbose
    flags << "-q" if keys.quiet
    flags = flags.join(' ').strip
    flags = ' ' + flags unless flags.empty?

    upload_stage(keys) do #|tmpdir|
      cmd = "scp -r#{flags} * #{keys.user}@#{keys.host}:/#{keys.root}"
      puts cmd unless keys.quiet
      system cmd unless keys.dryrun
    end
  end

  # Use rsync to upload files.

  def rsync( keys )
    keys = upload_parameters(keys)

    flags = []
    flags << "-n" if keys.dryrun
    flags << "-v" if keys.verbose
    flags << "-q" if keys.quiet
    flags = flags.join(' ').strip
    flags = ' ' + flags unless flags.empty?

    upload_stage(keys) do #|tmpdir|
      begin
        ENV['RSYNC_PASSWORD'] = keys.pass if keys.pass
        cmd = "rsync -R#{flags} -arz * #{keys.user}@#{keys.host} /#{keys.root}"
      ensure
        ENV.delete('RSYNC_PASSWORD') if keys.pass
      end
    end
  end

  # Use ftp to upload files.

  def ftp( keys )
    keys = upload_parameters(keys)

    if keys.dryrun
      puts "ftp open #{keys.user}@#{keys.host}:#{keys.root}/"
      keys.trans.each do |f, t|
        puts "ftp put #{f} #{t}"
      end
    else
      require 'net/ftp'
      Net::FTP.open(keys.host) do |ftp|
        ftp.login(keys.user) #password?
        ftp.chdir(keys.root)
        keys.trans.each do |f, t|
          puts "ftp #{f} #{t}" unless keys.quiet
          ftp.putbinaryfile( f, t, 1024 )
        end
      end
    end
  end

  # Use sftp to upload files.

  def sftp( keys )
    keys = upload_parameters(keys)

    if keys.dryrun
      puts "sftp open #{keys.user}@#{keys.host}:#{keys.root}/"
      keys.trans.each do |f,t|
        puts "sftp put #{f} #{t}"
      end
    else
      require 'net/sftp'
      Net::SFTP.start(keys.host, keys.user, keys.pass) do |sftp|
        #sftp.login( user )
        sftp.chdir(keys.root)
        keys.trans.each do |f,t|
          puts "sftp #{f} #{t}" unless keys.quiet
          sftp.put_file(f,t) #, 1024 )
        end
      end
    end
  end



  # Creates a stage from which the whole directory can be uploaded.
  # This is needed for scp and rsync which have to shelled out,
  # and can't conveniently copy one file at a time.

  def upload_stage(keys) #:yield:
    tmp = "scp_#{object_id.abs}_#{ Time.now.strftime("%Y%m%d%H%M%S")}"
    tmpdir = File.join(Dir.tmpdir,tmp)

    puts "mkdir -p #{tmpdir}" unless keys.quiet
    FileUtils.mkdir_p(tmpdir)  # go ahead and do this even if dryrun

    fu = keys.dryrun ? FileUtils::DryRun : FileUtils
    keys.trans.each do |f, t|
      to = File.join(tmpdir, t)
      fu.mv(f,to)
    end

    puts "cd #{tmpdir}" unless keys.quiet
    Dir.chdir(tmpdir) do
      yield #(tmpdir)
    end

    puts "rm -r #{tmpdir}" unless keys.quiet
    FileUtils.rm_r(tmpdir)  # now remove the temp dir
  end

=end

end
