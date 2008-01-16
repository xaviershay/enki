# = TITLE:
#
#   Populate
#
# = DESCRIPTION:
#
#   Kernel extensions for setting object state or
#   assigning variables.
#
# = AUTHORS:
#
#   - Thomas Sawyer
#
# = TODO:
#
#   - Change these to fit with object_ and instance_ conventions (?)

#
module Kernel

  # Similiar to #set_with, but ignores missing setters.
  #
  def populate( data=nil, &yld )
    if data
      data.each do |k,v|
        send( "#{k}=", v ) rescue nil
      end
    end

    if yld
      yld.to_h.each do |k,v|
        send( "#{k}=", v ) rescue nil
      end
    end

    # If the context of the error could be known
    # this could be used instead of converting the
    # block to a hash.

    #begin
    #  yield self
    #rescue NoMethodError => e
    #  if e.context == self and e.name.to_s =~ /=$/
    #    resume
    #  else
    #    raise e
    #  end
    #end

    self
  end

  # Assign via setter methods using a hash, associative
  # array or block.
  #
  #   object.set_with( :a => 1, :b => 2 )
  #   object.set_with( :a, 1, :b, 2 )
  #   object.set_with( [:a, 1], [:b, 2] )
  #   object.set_with( *[[:a, 1], [:b, 2]] )
  #   object.set_with{ |s| s.a = 1; s.b = 2 }
  #
  # These are all the same as doing:
  #
  #   object.a = 1
  #   object.b = 2
  #
  # The array forms gaurentees order of operation.
  #
  # This method does not check to make sure the object
  # repsonds to the setter method. For that see #populate.

  def set_with(*args) #:yield:
    harg = args.last.is_a?(Hash) ? args.pop : {}

    unless args.empty?
      # if not assoc array, eg. [ [], [], ... ]
      # preserves order of opertation
      unless args[0].is_a?(Array)
        i = 0; a = []
        while i < args.size
          a << [ args[i], args[i+1] ]
          i += 2
        end
        args = a
      end
    end

    args.each do |k,v|
      self.send( "#{k}=", v )
    end

    harg.each do |k,v|
      self.send( "#{k}=", v )
    end

    yield self if block_given?

    self
  end

  # Set setter methods using a another object.
  #
  #   class X
  #     attr_accessor :a, :b
  #     def initialize( a, b )
  #        @a,@b = a,b
  #     end
  #   end
  #
  #   obj1 = X.new( 1, 2 )
  #   obj2 = X.new
  #
  #   obj2.set_from(obj1)
  #
  #   obj2.a  #=> 1
  #   obj2.b  #=> 2
  #
  def set_from(obj, *fields)
    unless fields.empty?
      fields.each do |k|
        send( "#{k}=", obj.send("#{k}") )  #if self.respond_to?("#{k}=") && obj.respond_to?("#{k}")
      end
    else
      setters = methods.collect { |m| m =~ /=$/ }
      setters.each do |setter|
        getter = setter.chomp('=')
        if obj.respond_to?(getter)
          send( setter, obj.send(getter) )
          fields < getter
        end
      end
    end
    fields
  end

end
