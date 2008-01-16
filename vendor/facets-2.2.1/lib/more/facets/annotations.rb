# TITLE:
#
#   Annotation
#
# DESCRIPTION:
#
#   Annotations allows you to annontate objects, including methods with
#   arbitrary "metadata".
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer, George Moschovitis
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
#   - Thomas Sawyer
#   - George Moschovitis
#
# LOG:
#
#   - 2006-11-07 trans  Created this ultra-concise version of annotations.
#
# TODO:
#
#   - Might be nice to have a default object of annotation, eg. the next
#     method defined, like how +desc+ annotates a rake +task+.
#
#   - The ann(x).name notation is kind of nice. Would like to add that
#     back-in if reasonable. Basically this require heritage to be an OpenObject
#     rather than just a hash.
#

# Author::    Thomas Sawyer, George Moschovitis
# Copyright:: Copyright (c) 2005 Thomas Sawyer
# License::   Ruby License

require 'facets/conversion' # Hash#to_h
require 'facets/hash/rekey'
require 'facets/hash/op'

# = Annotation
#
# Annotations allows you to annontate objects, including methods with arbitrary
# "metadata". These annotations don't do anything in themselves. They are
# merely comments. But you can put them to use. For instance an attribute
# validator might check for an annotation called :valid and test against it.
#
# Annotation is an OpenObject, and is used across the board for keeping annotations.
#
# Annotation class serves for both simple and inherited cases depending on whether
# a base class is given.
#
# == Synopsis
#
#   class X
#     attr :a
#     ann :@a, :valid => lambda{ |x| x.is_a?(Integer) }
#
#     def validate
#       instance_variables.each { |iv|
#         if validator = self.class.ann(iv)[:valid]
#           value = instance_variable_get(iv)
#           unless validator.call(vale)
#             raise "Invalid value #{value} for #{iv}"
#           end
#         end
#       }
#     end
#
#   end

#--
# By using a global veriable rather the definining a class instance variable
# for each class/module, it is possible to quicky scan all annotations for the
# entire system. To do the same without this would require scanning through
# the ObjectSpace. (Still which is better?)
#
#$annotations = Hash.new { |h,k| h[k] = {} }
#++

class Module

  def annotations
    #$annotations[self]
    @annotations ||= {}
  end

  def heritage(ref)
    ref = ref.to_sym
    ancestors.inject({}) { |memo, ancestor|
      ancestor.annotations[ref] ||= {}
      ancestor.annotations[ref] + memo
    }
  end

  # Set or read annotations.

  def ann( ref, keys_or_class=nil, keys=nil )
    return heritage(ref) unless keys_or_class or keys

    if Class === keys_or_class
      keys ||= {}
      keys[:class] = keys_or_class
    else
      keys = keys_or_class
    end

    if Hash === keys
      ref = ref.to_sym
      annotations[ref] ||= {}
      annotations[ref].update(keys.rekey)
    else
      key = keys.to_sym
      heritage(ref)[key]
    end
  end

  # To change an annotation's value in place for a given class or module
  # it first must be duplicated, otherwise the change may effect annotations
  # in the class or module's ancestors.

  def ann!( ref, keys_or_class=nil, keys=nil )
    #return heritage(ref) unless keys_or_class or keys
    return annotations[ref] unless keys_or_class or keys

    if Class === keys_or_class
      keys ||= {}
      keys[:class] = keys_or_class
    else
      keys = keys_or_class
    end

    if Hash === keys
      ref = ref.to_sym
      annotations[ref] ||= {}
      annotations[ref].update(keys.rekey)
    else
      key = keys.to_sym
      annotations[ref][key] = heritage(ref)[key].dup
    end
  end

end
