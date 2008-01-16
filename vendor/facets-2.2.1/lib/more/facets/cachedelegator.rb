# TITLE:
#
#   CacheDelegator
#
# SUMMARY:
#
#   This mixin solely depends on method read(n), which must be
#   defined in the class/module where you mix in this module.
#
# COPYRIGHT:
#
#   Copyright (c) 2006 Erik Veenstra
#
# LICENSE:
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# AUTHORS:
#
#   - Erik Veenstra
#   - Thomas Sawyer


# = Cache
#
# Cache objects are a kind of "delegator-with-cache".
#
# == Usage
#
#   class X
#     def initialize ; @tick = 0 ; end
#     def tick; @tick + 1; end
#     def cached; @cache ||= Cache.new( self ) ; end
#   end
#
#   x = X.new
#   x.tick  #=> 1
#   x.cached.tick  #=> 2
#   x.tick  #=> 3
#   x.cached.tick  #=> 2
#   x.tick  #=> 4
#   x.cached.tick  #=> 2
#
# You can also use to cache a collections of objects to gain code
# speed ups.
#
#   points = points.collect{|point| Cache.cache(point)}
#
# After our algorithm has finished using points, we want to get rid of
# these Cache objects. That's easy:
#
#    points = points.collect{|point| point.self }
#
# Or if you prefer (it is ever so slightly safer):
#
#    points = points.collect{|point| Cache.uncache(point)}
#

class Cache

  private :class, :clone, :display, :type, :method, :to_a, :to_s

  def initialize(object)
    @self = object
    @cache = {}
  end

  def method_missing(method_name, *args, &block)
    # Not thread-safe! Speed is important in caches... ;]
    @cache[[method_name, args, block]] ||= @self.__send__(method_name, *args, &block)
  end

  def self; @self; end

  def self.cache(object)
    Cache.new(object)
  end

  def self.uncache(cached_object)
    cached_object.self
  end

end
