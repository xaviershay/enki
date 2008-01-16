require 'facets/indexable'
require 'facets/array/splice'

class Array
  include Indexable

  # Alias for #include?.
  #
  #   TODO: Maybe not appropriate for indexable.rb, but where?
  #
  #   CREDIT: Trans

  alias_method :contains?, :include?

  #alias_method :/, :[]

  # Alias for shift, which removes and returns
  # the first element in an array.
  #
  #  a = ["a","y","z"]
  #  a.first!      #=> "a"
  #  p a           #=> ["y","z"]
  #
  #   CREDIT: Trans

  alias_method :first!, :shift

  # Alias for pop, which removes and returns
  # the last element in an array.
  #
  #  a = [1,2]
  #  a.last! 3
  #  p a           #=> [1,2,3]
  #
  #   CREDIT: Trans

  alias_method :last!, :pop

  # Iteration object.

  class It
    attr_reader :index, :value, :prior, :after
    def initialize(array)
      @array = array
      @index = 0
      @value = array[0]
      @prior = []
      @after = array[1..-1]
    end
    def first? ; @index == 0 ; end
    def last?  ; @index == @array.length ; end
    private
    def next_iteration
      @index += 1
      @prior << @value
      @value = @after.shift
    end
  end

  # Iterate over each element of array using an iteration object.
  #
  #   [1,2,3].each_iteration do |it|
  #     p it.index
  #     p it.value
  #     p it.first?
  #     p it.last?
  #     p it.prior
  #     p it.after
  #   end
  #
  # on each successive iteration produces:
  #
  #   0          1          2
  #   1          2          3
  #   true       false      false
  #   false      false      true
  #   []         [1]        [1,2]
  #   [2,3]      [3]        []
  #
  #  CREDIT: Trans

  def each_iteration
    if block_given?
      it = It.new(self)
      each do |e|
        yield(it)
        it.send(:next_iteration)
      end
    else
      return Enumerable::Enumerator.new(self, :each_iteration)
    end
  end

end


=begin
class Array
  # TODO Probably not best to overide store and fetch operators. Rename?

  # Modifies #[] to also accept an array of indexes.
  #
  #   a = ['a','b','c','d','e','f']
  #
  #   a[[1]]      #=> ['b']
  #   a[[1,1]]    #=> ['b','b']
  #   a[[1,-1]]   #=> ['b','f']
  #   a[[0,2,4]]  #=> ['a','c','e']
  #
  def [](*args)
    return values_at(*args.at(0)) if Array === args.at(0)
    return slice(*args)
  end

  # Modifies #[]= to accept an array of indexes for assignment.
  #
  #   a = ['a','b','c','d']
  #
  #   a[[1,-1]] = ['m','n']    #=> ['m','n']
  #   a                        #=> ['a','m','c','n']
  #
  def []=(*args)
    if Array === args.at(0)
      idx,vals = args.at(0),args.at(1)
      idx.each_with_index{ |a,i| store(a,vals.at(i)) }
      return values_at( *idx )
    else
      return store(*args)
    end
  end
end
=end
