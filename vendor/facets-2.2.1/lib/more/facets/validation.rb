require 'facets/class/cattr'
require 'facets/module/on_included'
require 'facets/inheritor'
require 'facets/settings'

module Glue 

# Implements a meta-language for validating managed
# objects. Typically used in Validator objects but can be
# included in managed objects too.
#
# Additional og-related validation macros can be found
# in lib/og/validation.
#
# The following validation macros are available:
#
#  * validate_value
#  * validate_confirmation
#  * validate_format
#  * validate_length
#  * validate_inclusion
#
# Og/Database specific validation methods are added in the
# file og/validation.rb
#
# === Example
#
# class User
#    attr_accessor :name, String 
#    attr_accessor :level, Fixnum
#
#    validate_length :name, :range => 2..6 
#    validate_unique :name, :msg => :name_allready_exists 
#    validate_format :name, :format => /[a-z]*/, :msg => 'invalid format', :on => :create 
#  end
#
#  class CustomUserValidator 
#    include Validation
#    validate_length :name, :range => 2..6, :msg_short => :name_too_short, :msg_long => :name_too_long 
#  end
#
#  user = @request.fill(User.new)
#  user.level = 15
#
#  unless user.valid?
#    user.save
#  else
#    p user.errors[:name]
#  end
#
#  unless user.save
#    p user.errors.on(:name)
#  end
#
#  unless errors = CustomUserValidator.errors(user)
#    user.save
#  else
#    p errors[:name]
#  end
#--
# TODO: all validation methods should imply validate_value.
#++

module Validation

  # The postfix attached to confirmation attributes.
    
  setting :confirmation_postfix, :default => '_confirmation', :doc => 'The postfix attached to confirmation attributes.'

  # Encapsulates a list of validation errors.
  
  class Errors
    attr_accessor :errors 

    setting :no_value, :default => 'No value provided'
    setting :no_confirmation, :default => 'Invalid confirmation'
    setting :invalid_format, :default => 'Invalid format'
    setting :too_short, :default => 'Too short, must be more than %d characters long'
    setting :too_long, :default => 'Too long, must be less than %d characters long'
    setting :invalid_length, :default => 'Must be %d characters long'
    setting :no_inclusion, :default => 'The value is invalid'
    setting :no_numeric, :default => 'The value must be numeric'
    setting :not_unique, :default => 'The value is already used'
    
    def initialize(errors = {})
      @errors = errors
    end

    def add(attr, message)
      (@errors[attr] ||= []) << message
    end

    def on(attr)
      @errors[attr]
    end
    alias_method :[], :on
  
    # Yields each attribute and associated message.
    
    def each
      @errors.each_key do |attr| 
        @errors[attr].each { |msg| yield attr, msg }
      end
    end

    def size
      @errors.size
    end
    alias_method :count, :size

    def empty?
      @errors.empty?
    end

    def clear
      @errors.clear
    end

    def to_a
      @errors.inject([]) { |a, kv| a << kv }
    end
    
    def join(glue)
      @errors.to_a.join(glue)
    end
  end

  # A Key is used to uniquely identify a validation rule.
  
  class Key
    attr_reader :validation
    attr_reader :field

    def initialize(validation, field)
      @validation, @field = validation.to_s, field.to_s
    end

    def hash
      "#{@validation}-#{@field}".hash
    end

    def ==(other)
      self.validation == other.validation and self.field == other.field
    end
  end
    
  # If the validate method returns true, this
  # attributes holds the errors found.
  
  attr_accessor :errors

  # Call the #validate method for this object.
  # If validation errors are found, sets the
  # @errors attribute to the Errors object and 
  # returns true.
  
  def valid?
    validate
    @errors.empty?
  end
    
  # Evaluate the class and see if it is valid.
  # Can accept any parameter for 'on' event,
  # and defaults to :save

  def validate(on = :save)
    @errors = Errors.new

    return if self.class.validations.length == 0

    for event, block in self.class.validations
      block.call(self) if event == on.to_sym
    end
  end

  on_included %{
    base.module_eval do
      inheritor(:validations, [], :+) unless @validations
      # THINK: investigate carefuly!
      def self.included(cbase)
        super
        cbase.send :include, Glue::Validation
      end
    end
    base.extend(ClassMethods)
  }

  # Implements the Validation meta-language.
  
  module ClassMethods 
    # Validates that the attributes have a values, ie they are
    # neither nil or empty.
    #
    # === Example
    #
    # validate_value :param, :msg => 'No confirmation'
    
    def validate_value(*params)
      c = parse_config(params, :msg => Glue::Validation::Errors.no_value, :on => :save)

      params.each do |field|
        define_validation(:value, field, c[:on]) do |obj|
          value = obj.send(field)
          obj.errors.add(field, c[:msg]) if value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end
    end
=begin
    # Validates the confirmation of +String+ attributes.
    #
    # === Example
    #
    # validate_confirmation :password, :msg => 'No confirmation'
    
    def validate_confirmation(*params)
      c = parse_config(params,
        :msg => Glue::Validation::Errors.no_confirmation, 
        :postfix => Glue::Validation.confirmation_postfix,
        :on => :save 
      )

      params.each do |field|
        confirm_name = field.to_s + c[:postfix]
        attr_accessor confirm_name.to_sym

        define_validation(:confirmation, field, c[:on]) do |obj|
          value = obj.send(field)
          obj.errors.add(field, c[:msg]) if value.nil? or obj.send(confirm_name) != value
        end
      end
    end
=end
    # Validates the format of +String+ attributes.
    # WARNING: regexp options are ignored.
    #
    # === Example
    # 
    # validate_format :name, :format => /$A*/, :msg => 'My error', :on => :create
    #--
    # FIXME: how to get the Regexp options?
    #++

    def validate_format(*params)
      c = parse_config(params,
        :format => nil, 
        :msg_no_value => Glue::Validation::Errors.no_value,
        :msg => Glue::Validation::Errors.invalid_format, 
        :on => :save 
      )

      unless c[:format].is_a?(Regexp)
        raise ArgumentError, "A regular expression must be supplied as the :format option for validate_format."
      end

      params.each do |field|
        define_validation(:format, field, c[:on]) do |obj|
          value = obj.send(field)
          obj.errors.add(field, c[:msg]) if value.to_s !~ c[:format]
        end
      end                                                
    end
    
    # Validates the length of +String+ attributes.
    #
    # === Example
    # 
    # validate_length :name, :max => 30, :msg => 'Too long'
    # validate_length :name, :min => 2, :msg => 'Too sort'
    # validate_length :name, :range => 2..30
    # validate_length :name, :length => 15, :msg => 'Name should be %d chars long'
    
    LENGTHS = [:min, :max, :range, :length].freeze
    
    def validate_length(*params)
      c = parse_config(params,
#       :lengths => {:min => nil, :max => nil, :range => nil, :length => nil},
        :min => nil, :max => nil, :range => nil, :length => nil,
        :msg => nil, 
        :msg_no_value => Glue::Validation::Errors.no_value,
        :msg_short => Glue::Validation::Errors.too_short,
        :msg_long => Glue::Validation::Errors.too_long,
        :msg_invalid => Glue::Validation::Errors.invalid_length,
        :on => :save 
      )

      length_params = c.reject {|k,v| !LENGTHS.include?(k) || v.nil? }
      valid_count = length_params.reject{|k,v| v.nil?}.length
      
      if valid_count == 0
        raise ArgumentError, 'One of :min, :max, :range, or :length must be provided!'
      elsif valid_count > 1
        raise ArgumentError, 'You can only use one of :min, :max, :range, or :length options!'
      end

      operation, required = length_params.keys[0], length_params.values[0]
     
      params.each do |field|
        define_validation(:length, field, c[:on]) do |obj|
          msg = c[:msg]
          value = obj.send(field)
          if value.nil?
            obj.errors.add(field, c[:msg_no_value])
          else 
            case operation
            when :min
              msg ||= c[:msg_short]
              obj.errors.add(field, msg % required) if value.length < required
            when :max
              msg ||= c[:msg_long]
              obj.errors.add(field, msg % required) if value.length > required
            when :range
              min, max = required.first, required.last
              if value.length < min
                msg ||= c[:msg_short]
                obj.errors.add(field, msg % min)
              end
              if value.length > max
                msg ||= c[:msg_long]
                obj.errors.add(field, msg % min)
              end
            when :length
              msg ||= c[:msg_invalid]
              obj.errors.add(field, msg % required) if value.length != required
            end
          end
        end
      end
    end
    
    # Validates that the attributes are included in 
    # an enumeration.
    #
    # === Example
    #
    # validate_inclusion :sex, :in => %w{ Male Female }, :msg => 'huh??'
    # validate_inclusion :age, :in => 5..99 

    def validate_inclusion(*params)
      c = parse_config(params,
        :in => nil, 
        :msg => Glue::Validation::Errors.no_inclusion, 
        :allow_nil => false,
        :on => :save 
      )

      unless c[:in].respond_to?('include?')
        raise(ArgumentError, 'An object that responds to #include? must be supplied as the :in option')
      end

      params.each do |field|
        define_validation(:inclusion, field, c[:on]) do |obj|
          value = obj.send(field)
          unless (c[:allow_nil] && value.nil?) or c[:in].include?(value)
            obj.errors.add(field, c[:msg])
          end
        end
      end                                                
    end

    # Validates that the attributes have numeric values.
    #
    # [+:integer+]
    #    Only accept integers
    #
    #  [+:msg]
    #    Custom message
    #
    #  [+:on:]
    #    When to validate
    #    
    # === Example
    #
    # validate_numeric :age, :msg => 'Must be an integer'

    def validate_numeric(*params)
      c = parse_config(params, 
        :integer => false,
        :msg => Glue::Validation::Errors.no_numeric, 
        :on => :save 
      )

      params.each do |field|
        define_validation(:numeric, field, c[:on]) do |obj|
          value = obj.send(field).to_s
          if c[:integer] 
            unless value =~ /^[\+\-]*\d+$/
              obj.errors.add(field, c[:msg])
            end
          else
            begin
              Float(value)
            rescue ArgumentError, TypeError
              obj.errors.add(field, c[:msg])
            end
          end
        end
      end
    end
    alias_method :validate_numericality, :validate_numeric

  protected

    # Parse the configuration for a validation by comparing
    # the default options with the user-specified options,
    # and returning the results.

    def parse_config(params, defaults = {})
      defaults.update(params.pop) if params.last.is_a?(Hash)
      defaults
    end

    # Define a validation for this class on the specified event.
    # Specify the on event for when this validation should be
    # checked.
    #
    # An extra check is performed to avoid multiple validations.
    #
    # This example creates a validation for the 'save' event,
    # and will add an error to the record if the 'name' property
    # of the validating object is nil.
    #
    # === Example
    #
    # field = :name
    #
    # define_validation(:value, field, :save) do |object|
    #   object.errors.add(field, "You must set a value for #{field}") if object.send(field).nil?
    # end
    
    def define_validation(val, field, on = :save, &block)
      vk = Validation::Key.new(val, field)
      unless validations.find { |v| v[2] == vk }
        validations! << [on, block, vk]
      end
    end
    
  end

end

end

class Module # :nodoc: all
  include Glue::Validation::ClassMethods
end
