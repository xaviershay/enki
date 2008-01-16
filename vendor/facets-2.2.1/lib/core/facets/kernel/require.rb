# = TITLE:
#
#   Require / Load Extensions
#
# = DESCRIPTION:
#
#   Require/Load extensions.
#
# = AUTHORS:
#
#   - Thomas Sawyer

#
module Kernel

  private

  # Load file from same dir as calling script.
  #
  #   load_local 'templib'
  #
  def load_local(fname, safe=nil)
    #fdir = File.expand_path( File.dirname( caller[0] ) )
    fdir = File.dirname( caller[0] )
    load( File.join( fdir, fname ), safe )
  end

  # Require file from same dir as calling script.
  #
  #   require_local 'templib'
  #
  def require_local(fname)
    #fdir = File.expand_path( File.dirname( caller[0] ) )
    fdir = File.dirname( caller[0] )
    require( File.join( fdir, fname ) )
  end

  # Require a pattern of files. This make is easy
  # to require an entire directory, for instance.
  #
  #   require_all 'facets/time/*'
  #
  def require_all(pat)
    $LOAD_PATH.each do |path|
      fs = Dir[File.join(path,pat)]
      unless fs.empty?
        fs.each { |f|
          Kernel.require( f ) unless File.directory?( f )
        }
        break;
      end
    end
  end

end
