# TITLE:
#
#   Instantise
#
# SUMMARY:
#
#   Instantise converts module methods into instance methods
#   such that the first parameter is passed self at the instance level.
#   This promotes DRY programming when wishing to offer both an inheritable
#   and a module callable procedure.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer
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


# = Instantise
#
# Instantise converts a module's class methods into instance methods
# such that the first parameter is passed self at the instance level.
# This promotes DRY programming when wishing to offer both an inheritable
# and a module callable procedure.
#
# == Usage
#
#   module MyModule
#     extend Instantise
#
#     def self.jumble( obj, arg )
#       obj + arg
#     end
#   end
#
#   class String
#     include MyModule
#   end
#
#   MyModule.jumble( "Try", "Me" )  #=> "TryMe"
#
#   "Try".jumble( "Me" )            #=> 'TryMe'
#
module Instantise

  #alias_method :singleton_method_added_promoteself, :singleton_method_added if defined?(singleton_method_added)
  def singleton_method_added( meth )
    d = %{
      def #{meth}(*args)
        #{self.name}.#{meth}(self,*args)
      end
    }
    self.class_eval d
    #singleton_method_added_promoteself( meth ) if defined?(singleton_method_added_promoteself)
    super( meth ) #if defined?(singleton_method_added_promoteself)
  end

  # Just some expiremtneal thoughts about #is...

  #def self.append_feature_function
  #  :extend
  #end

  #def append_features(mod)
  #  mod.extend self
  #end

end

# Old name. To be deprecated.
PromoteSelf = Instantise



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  # fixture

  module MyModule
    extend Instantise
    def self.jumble( obj, arg )
      obj + arg
    end
  end

  class String
    include MyModule
  end

  # test

  class TC_PromoteSelf < Test::Unit::TestCase

    def test01
      assert_equal( 'TryMe', MyModule.jumble( "Try", "Me" ) )
    end

    def test02
      assert_equal( 'TryMe', "Try".jumble( "Me" ) )
    end

  end

=end
