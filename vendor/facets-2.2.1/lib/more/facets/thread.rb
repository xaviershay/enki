# TITLE:
#    Thread Extensions
#
# SUMMARY:
#   Thread extensions, in particular for Enumerable --send
#   a message to each member via a thread and collect the results.
#
# AUTHORS:
#   - Sean O'Halpin
#
# TODOs:
#   - Better names for these methods ?
#
# COPYRIGHT:
#   Copyright (c) 2006 Sean O'Halpin
#
# LICENSE:
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.

require 'thread'
require 'facets/enumerable/collect'  # for map_send

#
module Enumerable

  # Like Enumerable#map but each iteration is processed via
  # a separate thread.
  #
  # CREDIT Sean O'Halpin

  def threaded_map #:yield:
    map{|e| Thread.new(e){|t| yield t}}.map_send(:value)
  end

  # Like Enumerable#map_send but each iteration is processed via
  # a separate thread.
  #
  # CREDIT Sean O'Halpin

  def threaded_map_send(meth, *args) #:yield:
    if block_given?
      map{|e| Thread.new(e){|t| yield t.send(meth, *args)}}.map_send(:value)
    else
      map{|e| Thread.new(e){|t| t.send(meth, *args)}}.map_send(:value)
    end
  end

end
