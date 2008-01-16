class Range

  # Do two ranges overlap?
  #
  #   CREDIT: Daniel Schierbeck
  #   CREDIT: Brandon Keepers

  def overlap?(other)
    include?(other.first) or other.include?(first)
  end

  # Returns a two element array of the relationship
  # between two Ranges.
  #
  # Diagram:
  #
  #     Relationship     Returns
  #
  #   self |-----------|
  #   r    |-----------|    [0,0]
  #
  #   self |-----------|
  #   r     |---------|     [-1,-1]
  #
  #   self  |---------|
  #   r    |-----------|    [1,1]
  #
  #   self |-----------|
  #   r     |----------|    [-1,0]
  #
  #   self |-----------|
  #   r     |-----------|   [-1,1]
  #
  #   etc.
  #
  # Example:
  #
  #   (0..3).umbrella(1..2)  #=>  [-1,-1]
  #
  #   CREDIT: Trans
  #   CREDIT: Chris Kappler

  def umbrella(r)
    s = first <=> r.first
    e = r.last <=> last

    if e == 0
      if r.exclude_end? and exclude_end?
        e = r.max <=> max
      else
        e = (r.exclude_end? ? 0 : 1) <=> (exclude_end? ? 0 : 1)
      end
    end

    return s,e
  end

  # Uses the Range#umbrella method to determine
  # if another Range is _anywhere_ within this Range.
  #
  #   (1..3).within?(0..4)  #=> true
  #
  #   CREDIT: Trans

  def within?(rng)
    case rng.umbrella(self)
    when [0,0], [-1,0], [0,-1], [-1,-1]
      return true
    else
      return false
    end
  end

end
