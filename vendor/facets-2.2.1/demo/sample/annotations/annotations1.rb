require 'facets/annotations'

module M
       ann :this, :koko => []
       ann.this.koko! << 1
end

class C1
       include M
       ann.this.koko! << 2
       ann.this.koko! << 3
end


class C2
       include M
       ann.this.koko! << 4
end

p M.ann.this.koko # => expected [1]
p C1.ann.this.koko # => expected [1, 2, 3]
p C2.ann.this.koko # => expectes [1, 4]
