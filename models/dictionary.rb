module Models
  class Dictionary
    ##
    # files
    require_relative '../orm/dsl.rb'

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
    def initialize(name:, message: "", values: {})
      @table_name = name
      @message = message
      @values = values
    end

    attr_reader :table_name, :message, :values


    ##
    # I/O

    ##
    # DSL methods (should probably be included)

    # TODO add better pluralize
    def model_dir_name
      self.class.name.split("::").last.split(/(?=[A-Z])/).join("_").downcase.pluralize
    end

    def save
      ::Orm::Dsl::Interface.new(model_instance: self).save
    end


    ##
    # TODO

    def import_yml
      # imports entire yml file
    end

    def add_grouping

    end

    def add_key

    end

    def add_value

    end

    def keys

    end

  end
end