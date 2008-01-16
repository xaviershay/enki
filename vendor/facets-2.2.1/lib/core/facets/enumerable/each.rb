# TODO:
#
#   - Remove require 'enumerator' for Ruby 1.9.
#   - Suggest Enumerator's #each_slice use block arity if no parameter is given.

require 'enumerator' # for each_slice

module Enumerable

  # Iterate through slices. If slicing +step+ is not
  # given, the the arity if the block is used.
  #
  #   x = []
  #   [1,2,3,4].each_by{ |a,b| x << [a,b] }
  #   x  #=> [ [1,2], [3,4] ]
  #
  #   x = []
  #   [1,2,3,4,5,6].each_by(3){ |a| x << a }
  #   x  #=> [ [1,2,3], [4,5,6] ]
  #
  #   CREDIT: Trans

  def each_by(step=nil, &yld)
    if step
      each_slice(step,&yld)
    else
      step = yld.arity.abs
      each_slice(step,&yld)
    end
  end

  # Iterators over each element pairing.
  #
  #   [:a,:b,:c,:d].each_pair { |a,b|  puts "#{a} -> #{b}" }
  #
  # _produces_
  #
  #   a -> b
  #   c -> d
  #
  #   CREDIT: Martin DeMello

  def each_pair #:yield:
    e1 = nil
    each_with_index do |e,i|
      if i % 2 == 0
        e1 = e
        next
      else
        yield(e1,e)
      end
    end
  end

  # Collect each n items based on arity.
  #
  #   [1,2,3,4].eachn do |x, y|
  #     [x,y]
  #   end
  #
  # _produces_
  #
  #   [1,2]
  #   [3,4]
  #
  #   CREDIT: Martin DeMello

  def eachn(&block)
    n = block.arity.abs
    each_slice(n) {|i| block.call(*i)}
  end


  # DEPRECATED
  #
  #   # Why the term counter? There may be a change in Ruby 2.0
  #   # to use this word instead of index. Index will
  #   # still be used for Array, since that is the proper meaning
  #   # in that context. In the mean time, aliases are provided.
  #
  #   # More appropriate naming since an enumerable is not
  #   # neccesarily "indexed", as is an Array or Hash.
  #   alias_method :each_with_counter, :each_with_index

end

