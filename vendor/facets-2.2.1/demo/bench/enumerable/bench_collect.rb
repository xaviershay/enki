require 'benchmark'

module Enumerable

  # group_by

  def group_by_1(&block)
    h = k = e = nil
    r = Hash.new
    each{|e| (r[yield(e)] ||= []) << e}
    r
  end

  def group_by_2(&block)
    r = Hash.new{ |h,k| h[k]=[] }
    each{|e| r[yield(e)] << e}
    r
  end

  # cluster_by

  def cluster_by_1(&block)
    group_by_1(&block).values  # No sorting.
  end

  def cluster_by_2(&block)
    #partition_by_fast(&block).values.sort    # Sorted by value.
    group_by_1(&block).sort.transpose.pop  # Sorted by key.
  end

  def cluster_by_3(&block)        # As defined by Facets.
    h = {}
    each{|e| (h[block[e]] ||= []) << e}
    h.keys.sort!.map{|k| h[k]}        # Sorted by key.
  end

end

#

Benchmark.bmbm do |x|
  n = 10
  a = (0...10000).to_a + (0...10000).to_a
  h = (0...10000).inject({}){|h, e| h[e] = e ; h}

  # group_by

  x.report("group_by_1") do
    n.times do
      a.group_by_1{|e| e % 10}
      h.group_by_1{|k, v| v % 10}
    end
  end

  x.report("group_by_2") do
    n.times do
      a.group_by_2{|e| e % 10}
      h.group_by_2{|k, v| v % 10}
    end
  end

  # cluster_by

  x.report("cluster_by_1") do
    n.times do
      a.cluster_by_1{|e| e % 10}
      h.cluster_by_1{|k, v| v % 10}
    end
  end

  x.report("cluster_by_2") do
    n.times do
      a.cluster_by_2{|e| e % 10}
      h.cluster_by_2{|k, v| v % 10}
    end
  end

  x.report("cluster_by_3") do
    n.times do
      a.cluster_by_3{|e| e % 10}
      h.cluster_by_3{|k, v| v % 10}
    end
  end
end
