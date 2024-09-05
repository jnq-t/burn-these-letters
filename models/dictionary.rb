module Models
  class Dictionary
    ##
    # files
    require_relative '../orm/dsl.rb'
    require_relative '../helpers/key_symbolizer.rb'

    ##
    # dependencies
    require 'active_support/inflector'

    ##
    # class methods

    def self.find
      ## returns a given dictionary
    end

    ## param Name (the name of your model and your table)
    # param Message (message metadata for your dictionary. Think of this like a commit message)
    def initialize(name:, values: {})
      @name = name
      @values = KeySymbolizer.call(values)
    end

    attr_reader :name
    attr_accessor :values

    ##
    # loads the latest
    def load

      return unless user_wants_to_continue?
      interface.load
    end

    def load_backup(filename:)
      ::Orm::Dsl::Interface.new(model_instance: self).load_backup(filename)
    end


    def save(message: "")
      interface.save(message)
      # ::Orm::Dsl::Interface.new(model_instance: self).save(message)
    end

    ##
    #
    def model_dir_name
      self.class.name.split("::").last.split(/(?=[A-Z])/).join("_").downcase.pluralize
    end

    def import_yml
      # imports entire yml file
      # TODO
    end

    def add_grouping
      # TODO
    end

    def add_key
      # TODO
    end

    ##
    # will overwrite existing definitions
    def set_definition!(k, v)
      definition = KeySymbolizer.call({k => v})
      values.merge!(definition)
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
end