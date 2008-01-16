class Class

  # Creates a class-variable attribute that can
  # be accessed both on an instance and class level.
  #
  # NOTE These used to be a Module methods. But turns out
  # these to work as expected when included. The class-level
  # method is not carried along. So the are now just class
  # methods. Accordingly, #mattr will eventually be deprecated
  # so use #cattr instead.
  #
  #   CREDIT: David Heinemeier Hansson

  def cattr( *syms )
    accessors, readers = syms.flatten.partition { |a| a.to_s =~ /=$/ }
    writers = accessors.collect{ |e| e.to_s.chomp('=').to_sym }
    readers.concat( writers )
    cattr_writer( *writers )
    cattr_reader( *readers )
    return readers + accessors
  end

  alias_method :mattr, :cattr  # deprecate

  # Creates a class-variable attr_reader that can
  # be accessed both on an instance and class level.
  #
  #   class MyClass
  #     @@a = 10
  #     cattr_reader :a
  #   end
  #
  #   MyClass.a           #=> 10
  #   MyClass.new.a       #=> 10
  #
  #   CREDIT: David Heinemeier Hansson

  def cattr_reader( *syms )
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        def self.#{sym}
          @@#{sym}
        end
        def #{sym}
          @@#{sym}
        end
      EOS
    end
    return syms
  end

  alias_method :mattr_reader, :cattr_reader  # deprecate

  # Creates a class-variable attr_writer that can
  # be accessed both on an instance and class level.
  #
  #   class MyClass
  #     cattr_writer :a
  #     def a
  #       @@a
  #     end
  #   end
  #
  #   MyClass.a = 10
  #   MyClass.a            #=> 10
  #   MyClass.new.a = 29
  #   MyClass.a            #=> 29
  #
  #   CREDIT: David Heinemeier Hansson

  def cattr_writer(*syms)
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        def self.#{sym}=(obj)
          @@#{sym} = obj
        end
        def #{sym}=(obj)
          @@#{sym}=(obj)
        end
      EOS
    end
    return syms
  end

  alias_method :mattr_writer, :cattr_writer  # deprecate

  # Creates a class-variable attr_accessor that can
  # be accessed both on an instance and class level.
  #
  #   class MyClass
  #     cattr_accessor :a
  #   end
  #
  #   MyClass.a = 10
  #   MyClass.a           #=> 10
  #   mc = MyClass.new
  #   mc.a                #=> 10
  #
  #   CREDIT: David Heinemeier Hansson

  def cattr_accessor(*syms)
    m = []
    m.concat( cattr_reader(*syms) )
    m.concat( cattr_writer(*syms) )
    m
  end

  alias_method :mattr_accessor, :cattr_accessor  # deprecate

end
