# TITLE:
#
#   Multiton
#
# SUMMARY:
#
#   Multiton design pattern ensures only one object to be allocated
#   for a given object state.
#
# AUTHORS:
#
#   - Christoph Rippel
#   - Thomas Sawyer
#
# COPYRIGHT:
#
#   Copyright (c) 2007 Christoph Rippel, Thomas Sawyer
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

require 'thread'

# = Multiton
#
# Multiton design pattern ensures only one object is allocated for a given state.
#
# The 'multiton' pattern is similar to a singleton, but instead of only one
# instance, there are several similar instances.  It is useful when you want to
# avoid constructing objects many times because of some huge expense (connecting
# to a database for example), require a set of similar but not identical
# objects, and cannot easily control how many times a contructor may be called.
#
# == Synopsis
#
#   class SomeMultitonClass
#     include Multiton
#     attr :arg
#     def initialize(arg)
#       @arg = arg
#     end
#   end
#
#   a = SomeMultitonClass.new(4)
#   b = SomeMultitonClass.new(4)   # a and b are same object
#   c = SomeMultitonClass.new(2)   # c is a different object
#
# == Previous Behavior
#
# In previous versions of Multiton the #new method was made
# private and #instance had to be used in its stay --just like Singleton.
# But this is less desirable for Multiton since Multitions can
# have multiple instances, not just one.
#
# So instead Multiton now defines #create as a private alias of
# the original #new method (just in case it is needed) and then
# defines #new to handle the multiton; #instance is provided
# as an alias for it.
#
#--
# So if you must have the old behavior, all you need do is re-alias
# #new to #create and privatize it.
#
#   class SomeMultitonClass
#     include Multiton
#     alias_method :new, :create
#     private :new
#     ...
#   end
#
# Then only #instance will be available for creating the Multiton.
#++
#
# == How It Works
#
# A pool of objects is searched for a previously cached object,
# if one is not found we construct one and cache it in the pool
# based on class and the args given to the contructor.
#
# A limitation of this approach is that it is impossible to
# detect if different blocks were given to a contructor (if it takes a
# block).  So it is the constructor arguments _only_ which determine
# the uniqueness of an object. To workaround this, define the _class_
# method ::multiton_id.
#
#   def Klass.multiton_id(*args, &block)
#     # ...
#   end
#
# Which should return a hash key used to identify the object being
# constructed as (not) unique.

module Multiton

  #  disable build-in copying methods

  def clone
    raise TypeError, "can't clone Multiton #{self}"
    #self
  end

  def dup
    raise TypeError, "can't dup Multiton #{self}"
    #self
  end

  # default marshalling strategy

  protected

  def _dump(depth=-1)
    Marshal.dump(@multiton_initializer)
  end

  # Mutex to safely store multiton instances.

  class InstanceMutex < Hash  #:nodoc:
    def initialize
      @global = Mutex.new
    end

    def initialized(arg)
      store(arg, DummyMutex)
    end

    def (DummyMutex = Object.new).synchronize
      yield
    end

    def default(arg)
      @global.synchronize{ fetch(arg){ store(arg, Mutex.new) } }
    end
  end

  # Multiton can be included in another module, in which case that module effectively becomes
  # a multiton behavior distributor too. This is why we propogate #included to the base module.
  # by putting it in another module.
  #
  #--
  #    def append_features(mod)
  #      #  help out people counting on transitive mixins
  #      unless mod.instance_of?(Class)
  #        raise TypeError, "Inclusion of Multiton in module #{mod}"
  #      end
  #      super
  #    end
  #++

  module Inclusive
    private
    def included(base)
      class << base
        #alias_method(:new!, :new) unless method_defined?(:new!)
        # gracefully handle multiple inclusions of Multiton
        unless include?(Multiton::MetaMethods)
          alias_method :new!, :new
          private :allocate #, :new
          include Multiton::MetaMethods

          if method_defined?(:marshal_dump)
            undef_method :marshal_dump
            warn "warning: marshal_dump was undefined since it is incompatible with the Multiton pattern"
          end
        end
      end
    end
  end

  extend Inclusive

  #

  module MetaMethods

    include Inclusive

    def instance(*e, &b)
      arg = multiton_id(*e, &b)
      multiton_instance.fetch(arg) do
        multiton_mutex[arg].synchronize do
          multiton_instance.fetch(arg) do
            val = multiton_instance[arg] = new!(*e, &b) #new(*e, &b)
            val.instance_variable_set(:@multiton_initializer, e, &b)
            multiton_mutex.initialized(arg)
            val
          end
        end
      end
    end
    alias_method :new, :instance

    def initialized?(*e, &b)
      multiton_instance.key?(multiton_id(*e, &b))
    end

    protected

    def multiton_instance
      @multiton_instance ||= Hash.new
    end

    def multiton_mutex
      @multiton_mutex ||= InstanceMutex.new
    end

    def reinitialize
      multiton_instance.clear
      multiton_mutex.clear
    end

    def _load(str)
      instance(*Marshal.load(str))
    end

    private

    # Default method to to create a key to cache already constructed
    # instances. In the use case MultitonClass.new(e), MultiClass.new(f)
    # must be semantically equal if multiton_id(e).eql?(multiton_id(f))
    # evaluates to true.
    def multiton_id(*e, &b)
      e
    end

    def singleton_method_added(sym)
      super
      if (sym == :marshal_dump) & singleton_methods.include?('marshal_dump')
        raise TypeError, "Don't use marshal_dump - rely on _dump and _load instead"
      end
    end

  end

end




=begin
# TODO Convert this into a real test and/or benchmark.

if $0 == __FILE__

  ### Simple marshalling test #######
  class A
    def initialize(a,*e)
      @e = a
    end

    include Multiton
    begin
      def self.marshal_dump(depth = -1)
      end
    rescue => mes
      p mes
      class << self; undef marshal_dump end
    end
  end

  C = Class.new(A.clone)
  s = C.instance('a','b')

  raise unless Marshal.load(Marshal.dump(s)) == s


  ### Interdependent initialization example and threading benchmark ###

  class Regular_SymPlane
    def self.multiton_id(*e)
        a,b = e
        (a+b - 1)*(a+b )/2  + (a > b ? a : b)
    end

    def initialize(a,b)
      klass = self.class
      if a < b
        @l =  b > 0 ?  klass.instance(a,b-1) : nil
        @r =  a > 0 ?  klass.instance(a-1,b) : nil
      else
        @l =  a > 0 ?  klass.instance(a-1,b) : nil
        @r =  b > 0 ?  klass.instance(a,b-1) : nil
      end
    end

    include Multiton
  end



  def nap
  # Thread.pass
  sleep(rand(0.01))
  end

  class SymPlane < Regular_SymPlane
    @m = Mutex.new
    @count = 0
  end

  class << SymPlane
    attr_reader :count
    def reinitialize
      super
      @m = Mutex.new
      @count = 0
    end
    def inherited(sub_class)
      super
      sub_class.instance_eval { @m = Mutex.new; @count = 0 }
    end

    def multiton_id(*e)
      nap()
      super
    end

    def new!(*e)  # NOTICE!!!
      super
    ensure
      nap()
      @m.synchronize { p @count if (@count += 1) % 15 == 0 }
    end

    def run(k)
      threads = 0
      max = k * (k+1) / 2
      puts ""
      while count() < max
        Thread.new { threads+= 1; instance(rand(30),rand(30)) }
      end
      puts "\nThe simulation created #{threads} threads"
    end
  end


  require 'benchmark'
  include Benchmark

  bmbm do |x|
    x.report('Initialize 465 SymPlane instances') { SymPlane.run(30) }
    x.report('Reinitialize ') do
      sleep 3
      SymPlane.reinitialize
    end
  end

end
=end
