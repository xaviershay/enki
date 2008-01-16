module Enumerable

  # Same as #collect but with an iteration counter.
  #
  #   a = [1,2,3].collect_with_index { |e,i| e*i }
  #   a  #=> [0,2,6]
  #
  #   CREDIT: Gavin Sinclair

  def collect_with_index
    r = []
    each_index do |i|
      r << yield(self[i], i)
    end
    r
  end

  # Alias for collect_with_index.

  alias_method :map_with_index, :collect_with_index

  # Collects/Maps and filters items out in one single step.
  # You can use throw(:skip) in the supplied block to indicate that the
  # current item should not end up in the resulting array.
  #
  #   # Return names of all person with an age of at least 18.
  #   persons.filter_collect do |person|
  #     throw(:skip) if person.age < 18
  #     person.name
  #   end
  #
  # Also see Enumerable#collect, Enumerable#find_all.
  #
  #  CREDIT: Florian Gross

  def filter_collect #:yield:
    result = []
    self.each do |item|
      catch(:skip) do
        new_item = yield(item)
        result << new_item
      end
    end
    return result
  end

  # Alias for #filter_collect.

  alias_method :filter_map, :filter_collect

  # Collects/Maps and compacts items in one single step.
  # The items for which the supplied block returns +nil+ will not
  # end up in the resulting array.
  #
  #   # Return telephone numbers of all persons that have a telephone number.
  #   persons.compact_collect { |person| person.telephone_no }
  #
  # Also see Enumerable#collect, Enumerable#map, Array#compact.
  #
  #  CREDIT: Florian Gross

  def compact_collect #:yield:
    filter_collect do |item|
      new_item = yield(item)
      throw(:skip) if new_item.nil?
      new_item
    end
  end

  # Alias for #compact_collect.

  alias_method :compact_map, :compact_collect

  # Conditional collect.
  #
  #   [1,2,3].collect_if { |e| e > 1 }
  #
  #   CREDIT: ? Mauricio Fernandez

  def collect_if(&b)
    a = map(&b)
    # to get the same semantics as select{|e| e}
    a.delete(false)
    a.compact!
    a
  end

  # Alias for #collect_if.

  alias_method :map_if, :collect_if

  # Send a message to each element and collect the result.
  #
  #   CREDIT: Sean O'Halpin

  def map_send(meth, *args) #:yield:
    if block_given?
      map{|e| yield(e.send(meth, *args))}
    else
      map{|e| e.send(meth, *args)}
    end
  end

  #   # Cascade actions on each enumerated element.
  #   #
  #   #   [9, 19, 29].cascade :succ, :to_s, :reverse
  #   #   => ["01", "02", "03"]
  #   #
  #   # See ruby-talk:199877.
  #
  #   def cascade(*methods)
  #     methods.inject(self){ |ary, method| ary.map{ |x| x.send(method)}}
  #   end

  # Say you want to count letters--
  #
  #    some_text.inject!(Hash.new(0)) {|h,l| h[l] += 1}
  #
  # vs
  #
  #    some_text.inject(Hash.new(0)) {|h,l| h[l] +=1; h}
  #
  #   CREDIT: David Black

  def inject!(s)
    k = s
    each { |i| yield(k, i) }
    k
  end

  # Say you want to count letters--
  #
  #    some_text.injecting(Hash.new(0)) {|h,l| h[l] += 1}
  #
  # vs
  #
  #    some_text.inject(Hash.new(0)) {|h,l| h[l] +=1; h}
  #
  # This may be deprecated in favor of inject!. We make both
  # available for now to make sure (via the test of time) that
  # they are 100% equivalent.
  #
  #   CREDIT: Louis J Scoras

  def injecting(s)
    inject(s) do |k, i|
      yield(k, i); k
    end
  end


  # DEPRECATED:
  #
  #   # Why the term counter? There may be a change in Ruby 2.0
  #   # to use this word instead of index. Index will
  #   # still be used for Array, since that is the proper meaning
  #   # in that context. In the mean time, aliases are provided.
  #
  #   alias_method( :collect_with_counter, :collect_with_index )
  #   alias_method( :map_with_counter, :collect_with_index )
  #
  #   #instance_map and #instance_select --too invasive for convenience.

end
