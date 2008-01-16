# TITLE:
#
#   Conversions
#
# SUMMERY:
#
#   Conversion extensions.
#
#   _A horse is a horse, a horse of course!_
#
# AUTHORS:
#
#   - Thomas Sawyer
#   - Willian James
#   - Daniel Berger
#   - Forian Gross
#   - Mauricio Fernandez
#   - Nobuhiro Imai

require 'facets/functor'


class Array

  # Converts a two-element associative array into a hash.
  #
  #   a = [ [:a,1], [:b,2] ]
  #   a.to_h  #=> { :a=>1, :b=>2 }
  #
  # If +arrayed+ is set it will maintain trailing arrays.
  #
  #   a = [ [:a,1,2], [:b,3] ]
  #   a.to_h(true)  #=> { :a=>[1,2], :b=>[3] }
  #
  # Note that the use of a values parameter has been deprecated
  # because that functionality is as simple as:
  #
  #   array1.zip(array2).to_h
  #
  #   CREDIT: Trans

  def to_h(arrayed=nil)
    h = {}
    if arrayed #or (flatten.size % 2 == 1)
      #each{ |e| h[e.first] = e.slice(1..-1) }
      each{ |k,*v| h[k] = v }
    else
      #h = Hash[*flatten(1)] # TODO Use in 1.9 instead.
      ary = []
      each do |a|
        Array===a ? ary.concat(a) : ary << a
      end
      h = Hash[*ary]
    end
    h
  end

  # Turn an array into a file path.
  #
  #   ["usr", "local", "lib"].to_path  #=> "usr/local/lib"
  #
  #   CREDIT: Trans

  def to_path
    File.join( *(self.compact) )
  end

end


class Class

  # Convert instatiation of a class into a Proc.
  #
  #  class Person
  #     def initialize(name)
  #       @name = name
  #     end
  #
  #     def inspect
  #       @name.to_str
  #     end
  #   end
  #
  #   %w(john bob jane hans).map(&Person) => [john, bob, jane, hans]
  #
  #   CREDIT: Daniel Schierbeck

  def to_proc
    proc{|*args| new(*args)}
  end

end


module Enumerable

  # Produces a hash from an Enumerable with index for keys.
  #
  #   enu = 'a'..'b'
  #   enu.to_hash  #=> { 0=>'a', 1=>'b' }
  #
  # If a block is passed, the hash values will be set by
  # calling the block with the enumerated element and it's
  # counter.
  #
  #   enu = 'a'..'b'
  #   enu.to_hash{ |e,i| e }  #=> { 0=>'a', 1=>'b' }
  #
  # See also #mash.
  #
  #   CREDIT: Trans

  def to_hash( &blk )
    h = {}
    if blk
      each_with_index{ |e,i| h[i] = blk.call(e,i) }
    else
      each_with_index{ |e,i| h[i] = e }
    end
    h
  end

  # Convert an Enumerable object into a hash bu first
  # turning it into an array.
  #
  #   CREDIT: Trans

  def to_h(arrayed=nil)
    to_a.to_h(arrayed)
  end

end


class Hash

  # Return a rehashing of _self_.
  #
  #   {"a"=>1,"b"=>2}.to_h  #=> {"b"=>2,"a"=>1}
  #
  #   CREDIT: Forian Gross

  def to_h; rehash; end

  # Constructs a Proc object from a hash such
  # that the parameter of the Proc is assigned
  # the hash keys as attributes.
  #
  #   h = { :a => 1 }
  #   p = h.to_proc
  #   o = OpenStruct.new
  #   p.call(o)
  #   o.a  #=> 1
  #
  #   CREDIT: Trans

  def to_proc
    lambda do |o|
      self.each do |k,v|
        ke = "#{k}="
        o.__send__(ke, v)
      end
    end
  end

  # A fault-tolerent version of #to_proc.
  #
  # It works just like #to_proc, but the block will make
  # sure# the object responds to the assignment.
  #
  #   CREDIT: Trans

  def to_proc_with_reponse
    lambda do |o|
      self.each do |k,v|
        ke = "#{k}="
        o.__send__(ke, v) if respond_to?(ke)
      end
    end
  end

  # A method to convert a Hash into a Struct.
  #
  #   h = {:name=>"Dan","age"=>33,"rank"=>"SrA","grade"=>"E4"}
  #   s = h.to_struct("Foo")
  #
  #   CREDIT: Daniel Berger

  def to_struct(struct_name)
    Struct.new(struct_name,*keys).new(*values)
  end

end


class NilClass

  # Why doesn't Ruby have therese already?

  unless (RUBY_VERSION[0,3] == '1.9')

    # Allows <tt>nil</tt> to respond to #to_f.
    # Always returns <tt>0</tt>.
    #
    #   nil.to_f   #=> 0.0
    #
    #   CREDIT: Matz

    def to_f; 0.0; end

  end

  # Allows <tt>nil</tt> to create an empty hash,
  # similar to #to_a and #to_s.
  #
  #   nil.to_h    #=> {}
  #
  #   CREDIT: Trans

  def to_h; {}; end

end


class Proc

  # Build a hash out of a Proc.
  #
  #   l = lambda { |s|
  #     s.a = 1
  #     s.b = 2
  #     s.c = 3
  #   }
  #   l.to_h  #=> {:a=>1, :b=>2, :c=>3}
  #
  #   CREDIT: Trans

  def to_h
    h = {}
    f = Functor.new{ |op, arg| h[op.to_s.chomp('=').to_sym] = arg }
    call( f )
    h
  end

end


class Range

  # A thing really should know itself.
  # This simply returns _self_.
  #
  #   CREDIT: Trans

  def to_r
    self
  end

  # A thing really should know itself.
  # This simply returns _self_.
  #
  # Note: This does not internally effect the Ruby
  # interpretor such that it can coerce Range-like
  # objects into a Range.
  #
  #   CREDIT: Trans

  def to_range
    self
  end

end


class Regexp

  # Simply returns itself. Helpful when converting
  # strings to regular expressions, where regexp
  # might occur as well --in the same vien as using
  # #to_s on symbols. The parameter is actaully a
  # dummy parameter to coincide with String#to_re.
  #
  #   /abc/.to_re  #=> /abc/
  #
  #   CREDIT: Trans

  def to_re( esc=false )
    self  # Of course, things really should know how to say "I" ;)
  end

  # Like #to_re, but following Ruby's formal definitions,
  # only a Regular expression type object will respond to this.
  #
  # Note that to be of much real use this should be defined in core Ruby.
  #
  #   CREDIT: Florian Gross

  def to_regexp
    self
  end

end


class String

  # Get a constant by a given string name.
  #
  #   "Class".to_const   #=> Class
  #
  # Note this method is not as verstile as it should be,
  # since it can not access contants relative to the current
  # execution context. But without a binding_of_caller that
  # does not seem possible.
  #

  def to_const
    split('::').inject(Object){ |namespace,name| namespace.const_get(name) }
  end

  # Parse data from string.
  #
  #   CREDIT: Trans

  def to_date
    require 'date'
    require 'parsedate'
    ::Date::civil(*ParseDate.parsedate(self)[0..2])
  end

  # Parse string to time.
  #
  #   CREDIT: Trans

  def to_time
    require 'time'
    Time.parse(self)
  end

  # Turns a string into a regular expression.
  # By default it will escape all characters.
  # Use <tt>false</tt> argument to turn off escaping.
  #
  #   "[".to_re  #=> /\[/
  #
  #   CREDIT: Trans

  def to_re(esc=true)
    Regexp.new((esc ? Regexp.escape(self) : self))
  end

  # Turns a string into a regular expression.
  # Unlike #to_re this will not escape characters.
  #
  #   "a?".to_rx  #=> /a?/
  #
  #   CREDIT: Trans

  def to_rx
    Regexp.new(self)
  end

  # Evaluates a String as a Proc.
  #
  #   xyp = "|x,y| x + y".to_proc
  #   xyp.class      #=> Proc
  #   xyp.call(1,2)  #=> 3
  #
  #   NOTE: Sure would be nice if this could grab the caller's context!
  #
  #   CREDIT: Trans

  def to_proc(context=nil)
    if context
      if context.kind_of?(Binding) or context.kind_of?(Proc)
        Kernel.eval "proc { #{self} }", context
      else #context
        context.instance_eval "proc { #{self} }"
      end
    else
      Kernel.eval "proc { #{self} }"
    end
  end

  # Essentially makes #to_a an alias for split,
  # with the excpetion that if no divider is given
  # then the array is split on charaters, and
  # NOT on the global input record divider ($/).
  #
  # WARNING There is a slight chance of
  # incompatability with other libraries which
  # depend on spliting with $/ (although doing
  # so is a very bad idea!).

  #def to_a(div=//,limit=0)
  #  split(div,limit)
  #end

end


class Symbol

  unless (RUBY_VERSION[0,3] == '1.9')

    # Turn a symbol into a proc calling the method to
    # which it refers.
    #
    #   up = :upcase.to_proc
    #   up.call("hello")  #=> HELLO
    #
    # More useful is the fact that this allows <tt>&</tt>
    # to be used to coerce Symbol into Proc.
    #
    #   %w{foo bar qux}.map(&:upcase)   #=> ["FOO","BAR","QUX"]
    #   [1, 2, 3].inject(&:+)           #=> 6
    #
    #   TODO: Deprecate for Ruby 1.9+.
    #
    #   CREDIT: Florian Gross
    #   CREDIT: Nobuhiro Imai

    def to_proc
      Proc.new{|*args| args.shift.__send__(self, *args)}
    end

  end

  # Get a constant by a given symbol name.
  #
  #   :Class.to_const   #=> Class
  #
  # Note this method is not as verstile as it should be,
  # since it can not access contants relative to the current
  # execution context. But without a binding_of_caller that
  # does not seem possible.

  def to_const
    to_s.split('::').inject(Object){ |namespace,name| namespace.const_get(name) }
  end

  # Same functionality as before, just a touch more efficient.
  #
  #--
  # CHANGE transami@gmail.com - removed #freeze from #id2name
  # BAD BAD. Somehow it breaks things. Very weired breaks too,
  # like making Time#parse alwsy output Time.now _after_ first use.
  #++
  #def to_s
  #  @to_s || (@to_s = id2name)
  #end

  # Symbol's really are just simplified strings.
  # Thus #to_str seems quite reasonable.
  # This uses the Kernal#String method.
  #--
  # Maybe just change to #to_s?
  # BTW: This would be lots faster, I bet, if implemented in core.
  #
  # NOTE This cause Struct.new to bomb!
  #++
  #def to_str
  #  String( self )
  #end

end


class Time

  unless (RUBY_VERSION[0,3] == '1.9')

    # Convert a Time to a Date. Time is a superset of Date.
    # It is the year, month and day that are carried over.
    #
    #   CREDIT: Trans

    def to_date
      require 'date'
      ::Date.new(year, month, day)
    end

    # To be able to keep Dates and Times interchangeable
    # on conversions.
    #
    #   CREDIT: Trans

    def to_time
      self
    end

  end

end
