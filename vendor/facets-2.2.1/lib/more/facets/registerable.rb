# TITLE:
#
#   Registerable
#
# COPYING:
#
#   Copyright (c) 2007 Psi T Corp.
#

module Registerable

  # Register format names.

  def register(*names)
    names.each do |name|
      registry[name.to_s] = self
    end
  end

  # Access registry.

  def registry
    @@registry ||= {}
  end

  #

  def registry_invalid?(*types)
    bad = []
    types.each do |type|
      bad << type unless @@registry[type]
    end
    return bad.empty? ? false : bad
  end

end
