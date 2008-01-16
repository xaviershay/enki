class Object

  # Takes a hash and creates (singleton) attr_readers for each key.
  #
  #   with_reader { :x => 1, :y => 2 }
  #   @x       #=> 1
  #   @y       #=> 2
  #   self.x   #=> 1
  #   self.y   #=> 2
  #
  #   CREDIT: Trans

  def with_reader(h)
    (class << self ; self ; end).send( :attr_reader, *h.keys )
    h.each { |k,v| instance_variable_set("@#{k}", v) }
  end

  # Takes a hash and creates (singleton) attr_writers for each key.
  #
  #   with_writer { :x => 1, :y => 2 }
  #   @x           #=> 1
  #   @y           #=> 2
  #   self.x = 3
  #   self.y = 4
  #   @x           #=> 3
  #   @y           #=> 4
  #
  #   CREDIT: Trans

  def with_writer(h)
    (class << self ; self ; end).send( :attr_writer, *h.keys )
    h.each { |k,v| instance_variable_set("@#{k}", v) }
  end

  # Takes a hash and creates (singleton) attr_accessors
  # for each key.
  #
  #   with_accessor { :x => 1, :y => 2 }
  #   @x          #=> 1
  #   @y          #=> 2
  #   self.x = 3
  #   self.y = 4
  #   self.x      #=> 3
  #   self.y      #=> 4
  #
  #   CREDIT: Trans

  def with_accessor(h)
    (class << self ; self ; end).send( :attr_accessor, *h.keys )
    h.each { |k,v| instance_variable_set("@#{k}", v) }
  end

end
