require 'enumerator'

module Enumerable

  # Like <tt>#map</tt>/<tt>#collect</tt>, but generates a Hash.  The block
  # is expected to return two values: the key and the value for the new hash.
  #
  #   numbers  = (1..3)
  #   squares  = numbers.mash { |n| [n, n*n] }   # { 1=>1, 2=>4, 3=>9 }
  #   sq_roots = numbers.mash { |n| [n*n, n] }   # { 1=>1, 4=>2, 9=>3 }
  #
  # CREDIT: Trans
  # CREDIT: Andrew Dudzik (adudzik)
  #
  # NOTE: Would #correlate would be better?

  def mash(&yld)
    if yld
      inject({}) do |h, *kv| # Used to be inject({}) do |h,kv|
        r = *yld[*kv]        # The *-op works differnt from to_a on single element hash!!!
        nk, nv = *r          # Used to be nk, nv = *yld[*kv].to_a.flatten
        h[nk] = nv
        h
      end
    else
      Enumerator.new(self,:graph)  # Used to be Hash[*self.to_a] or Hash[*self.to_a.flatten]
    end
  end

  # Alias for #mash. This is the original name for this method.
  alias_method :graph, :mash

end


class Hash

  # In place version of #mash.
  #
  #   NOTE: Hash#mash! is only useful for Hash. It is not generally
  #         applicable to Enumerable.

  def mash!(&yld)
    replace(mash(&yld))
  end

  # Alias for #mash!. This is the original name for this method.
  alias_method :graph!, :mash!

end
