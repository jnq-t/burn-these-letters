require_relative 'base' # need to require the class before we

class Dictionary < Base
  ##
  # files
  require_relative '../orm/dsl'
  require_relative '../helpers/definition_formatter'
  require 'pry'

  ##
  # dependencies
  require 'active_support/inflector'

  ##
  # param Name (the name of your model and your table)
  def initialize(name:, values: {})
    @name = name
    @values = DefinitionFormatter.call(values)
  end

  attr_reader :name
  attr_accessor :values

  ##
  # class methods
  def self.foo
    binding.pry
  end

  def self.by_definition_key(key)
    self.all.select { |dict| dict.keys.include?(key) }
  end

  def self.by_definition_value(value)
    self.all.select do |dict|
      dict.values.select{ |_,v| v == value }
    end
  end


  ##
  # loads the latest
  def load
    return unless user_wants_to_continue?
    super
  end

  ##
  # returns the definitons that we actually use for scramlbing
  def definitions
    values_memo = values
    values_memo.delete("metadata")
    values_memo
  end

  ##
  # will overwrite existing definitions
  def set_definition!(definition)
    definition = DefinitionFormatter.call(definition)
    values.merge!(definition)
    self
  end

  def add_to_definition(definition)
    definition = DefinitionFormatter.call(definition)
    key = definition.keys.first
    unless keys.include? key
      puts "no definition matching that key found. Use #set_definition! instead."
      return self
    end
    values[key] += definition.values.first # the formatted will automatically wrap them in an array
    self
  end

  def keys
    values.keys
  end

  private

  def user_wants_to_continue?
    return true if missing_keys.empty?
    missing_values = values.select { |k,_| missing_keys.include?(k) }
    if missing_values.any?
      puts "you have the following unsaved values in the current dictionary: #{missing_values}. Consider saving first."
      response = load_warning_flow
      while response.nil?
        response = load_warning_flow
      end
      response
    end
  end

  def missing_keys
    saved_values = interface.find_table
    return [] unless saved_values.present?
    saved_values.delete("metadata")
    keys - saved_values.keys
  end

  def load_warning_flow
    case get_user_input("Continue with load? (Y/n):")
    when "y"
      puts "loading"
      return true
    when "n"
      puts "canceling load"
      return false
    else
      puts "unrecognized input, try again"
    end
  end

  ##
  # returns downcased user input
  def get_user_input(message)
    puts message
    gets.chomp.downcase
  end

  def method_missing(symbol)
    self.values[symbol].presence || "no definitions for '#{symbol}'. set definitions using #set_definition!"
  end
end