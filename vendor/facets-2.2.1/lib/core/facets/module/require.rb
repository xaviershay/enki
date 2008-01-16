unless (RUBY_VERSION[0,3] == '1.9')

  class Module

    # Load file into module/class namespace.
    #
    #   CREDIT: Trans

    def module_load( path )
      if path =~ /^[\/~.]/
        file = File.expand_path(path)
      else
        $LOAD_PATH.each do |lp|
          file = File.join(lp,path)
          break if File.exist?(file)
          file = nil
        end
      end

      module_eval(File.read(file))
    end

    # Require file into module/class namespace.
    #
    #   CREDIT: Trans

    def module_require( path )
      if path =~ /^[\/~.]/
        file = File.expand_path(path)
      else
        $LOAD_PATH.each do |lp|
          file = File.join(lp,path)
          break if File.exist?(file)
          file += '.rb'
          break if File.exist?(file)
          file = nil
        end
      end
      @loaded ||= {}
      if @loaded.key?(file)
        false
      else
        @loaded[file] = true
        script = File.read(file)
        module_eval(script)
        true
      end
    end
  end


  class Class
    alias_method :class_load, :module_load
    alias_method :class_require, :module_require
  end

end