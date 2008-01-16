# TITLE:
#
#   Settings
#
# DESCRIPTION:
#
#   Settings holds configuration information organized by
#   Owners. An owner is a class that represents the system to be
#   configured. An alias for this class is Settings.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 George Moschovitis
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
#   - George Moschovitis
#
# TODO:
#
#   - Implement with annotations.

require 'yaml'
require 'facets/kernel/constant'
require 'facets/string/case' # for capitalized?
require 'facets/synchash'
require 'facets/dictionary'

# = Settings
#
# Settings holds configuration information organized by
# Owners. An owner is a class that represents the system to be
# configured. An alias for this class is Settings.
#
# You can pass strings, constants or symbols as keys for the
# classes to be configured. Passing symbols you can configure
# classes even before they are defined.
#
class Settings

  # A hash of setting owners. Use double @'s to allow for
  # the Settings alias.
  #--
  # TODO: find a better name.
  #++

  @@owners = SyncHash.new

  # A datastructure to store Settings metadata.
  #
  # Please note the difference between :default and :value,
  # :default does NOT override :value.

  class Setting
    attr_accessor :owner, :name, :type, :value, :options

    def initialize(owner, name, options)
      if options.key? :value
        @value = options[:value]
      elsif options.key? :default
        @value = options[:default]
      else
        raise ArgumentError.new('A value is required')
      end

      @owner, @name = owner, name
      @options = options
      @type = options[:type] = options[:type] || @value.class
    end

    # Update the setting from an options hash. The update does
    # NOT take default values into account!

    def update(hash)
      if hash.key? :value
        @value = hash[:value]
        @type = @value.class
      end

      if hash.key? :type
        @type = hash[:type]
      end

      @options.update(hash)
    end

    # Text representation of this setting.

    def to_s
      @value.to_s
    end

  end

  # A collection of Settings. This helper enables intuitive
  # settings initialization like this:
  #
  # Settings.Compiler.template_root = 'public'
  # instead of
  # Settings.setting :compiler, :template_root, :value => 'public'

  class SettingCollection < Hash
    attr_accessor :owner

    # Handles setting readers and writers.

    def method_missing(sym, *args)
      if sym.to_s =~ /=$/
        # Remove trailing
        sym = sym.to_s.gsub(/=/, '').to_sym
        Settings.setting @owner, sym, :value => args.first
      else
        self[sym]
      end
    end
  end

  class << self

    # Inject the Settings parameters provided as a hash
    # (dictionary, ordered) to classes to be configured.
    #
    # === Warning: Pass an ordered hash (dictionary)

    def setup(options)
      options.each do |owner, ss|
        next unless ss
        ss.each do |name, s|
          add_setting(owner, name.to_sym, :value => s)
        end
      end
    end

    # Parse Settings parameters in yaml format.

    def parse(options)
      temp = YAML::load(options)
      options = Dictionary.new
      temp.each do |k, v|
        begin
          options[k.gsub(/\./, '::').to_sym] = v
        rescue Object
          options[k] = v
        end
      end

      setup(options)
    end

    # Load and parse an external yaml Settings file.

    def load(filename)
      parse(File.read(filename))
    end

    # Manually add a Settings setting. The class key can
    # be the actual class name constant or a symbol. If the
    # setting is already defined it updates it.
    #
    # === Examples
    #
    # Settings.add_setting Compiler, :verification, :value => 12, :doc => '...'
    # Settings.setting :IdPart, :verify_registration_email, :value => false
    # s = Settings.Compiler.verification.value

    def add_setting(owner, name, options)
      owner = owner.to_s.to_sym
      @@owners[owner] ||= {}
      if s = @@owners[owner][name]
        # The setting already exists, update it.
        s.update(options)
      else
        # The setting does not exist, create it.
        @@owners[owner][name] = Setting.new(owner, name, options)
      end
    end
    alias_method :setting, :add_setting

    # Return the settings for the given owner. The owner is
    # typically the Class that represents the system to be
    # configured. If no class is provided, it returns all the
    # registered settings.

    def settings(owner = nil)
      if owner
        owner = owner.to_s.to_sym
        @@owners[owner]
      else
        @@owners.values.inject([]) { |memo, obj| memo.concat(obj.values) }
      end
    end
    alias_method :all, :settings
    alias_method :[], :settings

    #--
    # FIXME: this does not work as expected.
    #++

    def method_missing(sym)
      if sym.to_s.capitalized?
         bdl = SettingCollection.new
         bdl.owner = sym
         if hash = self[sym]
           bdl.update(hash)
         end
         return bdl
      end
    end
  end

end


class Module

  # Defines a configuration setting for the enclosing class.
  #
  # === Example
  #
  # class Compiler
  #   setting :template_root, :default => 'src/template', :doc => 'The template root dir'
  # end

  def setting(sym, options = {})
    Settings.add_setting(self, sym, options)

    module_eval %{
      def self.#{sym}
        Settings[#{self}][:#{sym}].value
      end

      def self.#{sym}=(obj)
        Settings.setting #{self}, :#{sym}, :value => obj
      end
    }
  end

end

