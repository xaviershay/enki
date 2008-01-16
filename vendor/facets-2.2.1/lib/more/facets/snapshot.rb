# TITLE:
#
#   Snapshot
#
# SUMMARY:
#
#   A lightweight single-depth object state capture.
#
# COPYRIGHT:
#
#   Copyright (c) 2004 Michael Neumann
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
# Authors:
#   - Michael Neumann
#
# TODOs:
#
#   - TODO Perhaps extend to offer multiple depths.
#
#   - TODO Should key consitancy be enforced? Currently
#          Struct's will have symbol keys while other classes
#          will have string keys in the form of "@name".
#
#   - TODO Add other core classes.
#
#   - TODO Convert to Kernel#to_data ?
#
#   - TODO I've been thinking about renaming this to State.


# = Snapshot
#
# A lightweight single-depth object state capture.
# The #take_snapshot method reads the object's state,
# which is generally it's collection of instance variables,
# and returns them in a hash. The state can be restored
# with #apply_snapshot.
#
# == Usage
#
#   Customer = Struct.new("Customer", :name, :address, :zip)
#   joe = Customer.new( "Joe Pitare", "1115 Lila Ln.", 47634 )
#
#   # simple transactions
#   joe_snap = joe.take_snapshot
#   begin
#     do_something_with( joe )
#   rescue
#     joe.apply_snapshot( joe_snap )
#   end
#
#   joe_snap[:name]     => "Joe Pitare"
#   joe_snap[:address]  => "1115 Lila Ln."
#   joe_snap[:zip]      => 47634
#
# == Details
#
# Class Snapshot simply represents a collection of objects from
# which snapshots were taken via their methods #take_snapshot.
# It provides methods to add an object to a snapshot
# (Snapshot#add) as well as to restore all objects
# of the snapshot to their state stored in the snapshot (method
# Snapshot#restore).
#
# In Wee, this class is used to backtracking the state of
# components (or decorations/presenters). Components that want
# an undo-facility to be implemented (triggered for example by
# a browsers back-button), have to overwrite the
# Wee::Component#backtrack_state method.

class Snapshot
  def initialize
    @objects = Hash.new
  end

  def add(object)
    oid = object.object_id
    @objects[oid] = [object, object.take_snapshot] unless @objects.include?(oid)
  end

  def restore
    @objects.each_value do
      |object, value| object.restore_snapshot(value)
    end
  end
end

# Simplist form of a snapshot.
#
#module SnapshotMixin
#  def take_snapshot() dup end
#  def restore_snapshot(snap) replace(snap) end
#end

# Implements a value holder. In Wee this is useful for
# backtracking the reference assigned to an instance variable
# (not the object itself!). An example where this is used is the
# <tt>@__decoration</tt> attribute of class Wee::Component.

class Snapshot::ValueHolder
  attr_accessor :value

  def initialize(value=nil)
    @value = value
  end

  def take_snapshot
    @value
  end

  def restore_snapshot(value)
    @value = value
  end
end

#--
# Extend some base classes of Ruby (Object, Array, String, Hash,
# Struct) for the two methods #take_snapshot and
# #restore_snapshot, required by Snapshot.
#++

class Object
  def take_snapshot
    snap = Hash.new
    instance_variables.each do |iv|
      snap[iv] = instance_variable_get(iv)
    end
    snap
  end
  
  def to_data
    task_snapshot
  end

  def restore_snapshot(snap)
    instance_variables.each do |iv|
      instance_variable_set(iv, snap[iv])
    end
  end

  def from_data(snap)
    restore_snapshot(snap)
  end
end

class Array
  def take_snapshot() dup end
  def restore_snapshot(snap) replace(snap) end
end

class String
  def take_snapshot() dup end
  def restore_snapshot(snap) replace(snap) end
end

class Hash
  def take_snapshot() dup end
  def restore_snapshot(snap) replace(snap) end
end

class Struct
  def take_snapshot
    snap = Hash.new
    each_pair {|k,v| snap[k] = v}
    snap
  end

  def restore_snapshot(snap)
    snap.each_pair {|k,v| send(k.to_s + "=", v)}
  end
end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

require 'test/unit'

class TestSnapshot < Test::Unit::TestCase

  def setup
    customer = Struct.new(:name, :address, :zip)
    joe = customer.new( "Joe Pitare", "1115 Lila Ln.", 47634 )
    @joe_snap = joe.take_snapshot
  end

  def test_storage
    assert_equal( "Joe Pitare", @joe_snap[:name]  )
    assert_equal( "1115 Lila Ln.", @joe_snap[:address] )
    assert_equal( 47634, @joe_snap[:zip] )
  end

end

=end
