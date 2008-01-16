class Dir

  # Like +glob+ but can take multiple patterns.
  #
  #   Dir.multiglob( '*.rb', '*.py' )
  #
  # Rather then constants for options multiglob accepts a trailing options
  # hash of symbol keys.
  #
  #   :noescape    File::FNM_NOESCAPE
  #   :casefold    File::FNM_CASEFOLD
  #   :pathname    File::FNM_PATHNAME
  #   :dotmatch    File::FNM_DOTMATCH
  #   :strict      File::FNM_PATHNAME && File::FNM_DOTMATCH
  #
  # It also has an option for recurse.
  #
  #   :recurse     Recurively include contents of directories.
  #
  # For example
  #
  #   Dir.multiglob( '*', :recurse => true )
  #
  # would have the same result as
  #
  #   Dir.multiglob('**/*')
  #
  # Multiglob also accepts '+' and '-' prefixes. Any entry that begins with a '-'
  # is treated as an exclusion glob and will be removed from the final result.
  # For example, to collect all files in the current directory, less ruby scripts:
  #
  #   Dir.multiglob( '*', '-*.rb' )
  #
  # This is very useful in collecting files as specificed by a configuration
  # parameter.

  def self.multiglob(*patterns)
    options  = (Hash === patterns.last ? patterns.pop : {})

    bitflags = 0
    bitflags |= File::FNM_NOESCAPE if options[:noescape]
    bitflags |= File::FNM_CASEFOLD if options[:casefold]
    bitflags |= File::FNM_PATHNAME if options[:pathname] or options[:strict]
    bitflags |= File::FNM_DOTMATCH if options[:dotmatch] or options[:strict]

    patterns = [patterns].flatten.compact

    if options[:recurse]
      patterns += patterns.collect{ |f| File.join(f, '**', '*') }
    end

    files = []
    files += patterns.collect{ |pattern| Dir.glob(pattern, bitflags) }.flatten.uniq

    return files
  end

  # The same as +multiglob+, but recusively includes directories.
  #
  #   Dir.multiglob_r( 'folder' )
  #
  # is equivalent to
  #
  #   Dir.multiglob( 'folder', :recurse=>true )
  #
  # The effect of which is
  #
  #   Dir.multiglob( 'folder', 'folder/**/*' )

  def self.multiglob_r(*patterns)
    options = (Hash === patterns.last ? patterns.pop : {})
    options[:recurse] = true
    patterns << options
    multiglob(*patterns)
  end

end
