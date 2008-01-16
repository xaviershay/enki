module Enumerable

  unless (RUBY_VERSION[0,3] == '1.9')
    # #group_by is used to group items in a collection by something they
    # have in common.  The common factor is the key in the resulting hash, the
    # array of like elements is the value.
    #
    #   (1..5).group_by { |n| n % 3 }
    #        #=> { 0 => [3], 1 => [1, 4], 2 => [2,5] }
    #
    #   ["I had", 1, "dollar and", 50, "cents"].group_by { |e| e.class }
    #        #=> { String => ["I had","dollar and","cents"], Fixnum => [1,50] }
    #
    #   CREDIT: Erik Veenstra
    #
    # TODO:
    #   - Deprecate #group_by when released for Ruby 1.9.

    def group_by #:yield:
      #h = k = e = nil
      r = Hash.new
      each{ |e| (r[yield(e)] ||= []) << e }
      r
    end
  end

  # This alias is the original Facets name for the method, but Ruby 1.9 has
  # adopted #group_by as the name, so eventually #partition_by will be deprecated.

  alias_method :partition_by, :group_by

  # Split on matching pattern. Unlike #divide this does not include matching elements.
  #
  #   ['a1','a2','b1','a3','b2','a4'].split(/^b/)
  #   => [['a1','a2'],['a3'],['a4']]
  #
  # CREDIT: Trans

  def split(pattern)
    memo = []
    each do |obj|
      if pattern === obj
        memo.push []
      else
        memo.last << obj
      end
    end
    memo
  end

  # Divide on matching pattern.
  #
  #   ['a1','b1','a2','b2'].divide(/^a/)
  #   => [['a1,'b1'],['a2','b2']]
  #
  #   CREDIT: Trans

  def divide(pattern)
    memo = []
    each do |obj|
      memo.push [] if pattern === obj
      memo.last << obj
    end
    memo
  end

  # Similar to #group_by but returns an array of the groups.
  # Returned elements are sorted by block.
  #
  #    %w{this is a test}.cluster_by {|x| x[0]}
  #
  # _produces_
  #
  #    [ ['a'], ['is'], ['this', 'test'] ]
  #
  # CREDIT Erik Veenstra

  def cluster_by(&b)
    group_by(&b).sort.transpose.pop || []   # group_by(&b).values ?
  end

  # Modulate. Divide an array into groups by modulo of the index.
  #
  # [2,4,6,8].modulate(2)  #=> [[2,6],[4,8]]
  #
  # CREDIT: Trans
  #
  # NOTE: Would this be better named 'collate'?

  def modulate(modulo)
    return to_a if modulo == 1
    raise ArgumentError, 'bad modulo' if size % modulo != 0
    r = Array.new(modulo, [])
    (0...size).each do |i|
      r[i % level] += [self[i]]
    end
    r
  end

  # DEPRECATED -- Use 'each_slice(n).to_a' as of 1.9.
  # Partition an array into parts of given length.
  #
  # CREDIT WhyTheLuckyStiff
  #
  #   def / len
  #     inject([]) do |ary, x|
  #       ary << [] if [*ary.last].nitems % len == 0
  #       ary.last << x
  #       ary
  #     end
  #   end

end
