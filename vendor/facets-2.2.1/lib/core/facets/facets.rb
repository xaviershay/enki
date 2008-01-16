# Facets Module

module Facets
  extend self

  # REMOVED "facets/basicobject" b/c of coming 1.9.
  # REMOVED "facets/continuaiton" b/c of coming 1.9.

  def require_core
   require "facets/array"
   require "facets/binding"
   require "facets/boolean"
   require "facets/class"
   require "facets/comparable"
   require "facets/conversion"
   require "facets/curry"
   require "facets/dir"
   require "facets/enumerable"
   require "facets/exception"
   require "facets/file"
   require "facets/filetest"
   require "facets/float"
   require "facets/functor"
   require "facets/hash"
   require "facets/indexable"
   require "facets/integer"
   require "facets/kernel"
   require "facets/lazy"
   require "facets/matchdata"
   require "facets/module"
   require "facets/nackclass"
   require "facets/nilclass"
   require "facets/nullclass"
   require "facets/numeric"
   require "facets/pathname"
   require "facets/proc"
   require "facets/range"
   require "facets/regexp"
   require "facets/stackable"
   require "facets/string"
   require "facets/symbol"
   require "facets/time"
   require "facets/unboundmethod"
  end
end

# Bring it on-line!
Facets.require_core

