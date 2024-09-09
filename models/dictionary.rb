class Dictionary
  ##
  # files
  require_relative '../orm/dsl.rb'
  require_relative '../helpers/key_symbolizer.rb'

  ##
  # dependencies
  require 'active_support/inflector'

  MODEL_DIR_NAME = self.name.demodulize.downcase.pluralize # TODO include this in the DSL via sometype of hook

  ##
  # param Name (the name of your model and your table)
  def initialize(name:, values: {})
    @name = name
    @values = KeySymbolizer.call(values)
  end

  attr_reader :name
  attr_accessor :values

  ##
  # class methods

  def self.list_all
    ::Orm::Dsl::Interface.list_all_tables(:model_name => MODEL_DIR_NAME)
  end

  def self.all
    ::Orm::Dsl::Interface.load_all_tables(:model_name => MODEL_DIR_NAME)
  end


  ##
  # loads the latest
  def load
    return unless user_wants_to_continue?
    interface.load
  end

  ##
  # loads a specific backup
  def load_backup(filename:)
    interface.load_backup(filename)
  end

  ##
  # saves the current state
  # param Message (message metadata for your dictionary. Think of this like a commit message)
  def save(message: "")
    interface.save(message)
  end

  def import_yml
    # imports entire yml file
    # TODO
  end

  ##
  # will overwrite existing definitions
  def set_definition!(k, v)
    definition = KeySymbolizer.call({k => v})
    values.merge!(definition)
  end

  def add_to_definition(k,v)
    definition = KeySymbolizer.call(k)
    if !keys.include? definition
      puts "no definition matching that key found. Use #set_definition! instead."
      return self
    end
    values[definition] += v
  end

  def keys
    values.keys
  end

  ##
  # TODO this method is required for the DSL integration
  # This should maybe be included in an adapter class that's inherited
  # Same thing with the initializer methods
  # Anything that's required for the DSL should be encapsulated
  # maybe in a module that can be included in a model_base class and inhereted among all models
  def model_dir_name
    MODEL_DIR_NAME
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

  def set_attributes!
    values.keys.each do |key|
      self.class.module_eval { attr_accessor key}
      self.send("#{key}=", values[key])
    end
  end

  def interface
    ::Orm::Dsl::Interface.new(:model_instance => self)
  end
end