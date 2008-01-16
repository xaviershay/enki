require 'benchmark'

module Enumerable

  # duplicates

  def duplicates_1
    h1 = {}
    h2 = {}
    each {|i|
      h2[i] = true if h1[i]
      h1[i] = true
    }
    h2.keys
  end

  def duplicates_2
    inject(Hash.new(0)){|h,v| h[v]+=1; h}.reject{|k,v| v==1}.keys
  end

  # uniq_by

  def uniq_by_1 #:yield:
    h = {}; inject([]) {|a,x| h[yield(x)] ||= a << x}
  end

  def uniq_by_2
    inject({}) { |h,x| h[yield(x)] ||= x; h }.values
  end

end

#

Benchmark.bmbm do |x|
  n = 10000
  a = [1,1,2,3,4,4,5,6,7,7]

  # duplicates

  x.report("duplicates_1") do
    n.times { a.duplicates_1 }
  end

  x.report("duplicates_2") do
    n.times { a.duplicates_2 }
  end

  # uniq_by

  x.report("uniq_by_1") do
    n.times { a.uniq_by_1{ |x| x } }
  end

  x.report("uniq_by_2") do
    n.times { a.uniq_by_2{ |x| x } }
  end
end
