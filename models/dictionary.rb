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

    def initialize(name:)
      @table_name = name
    end

    ##
    # I/O

    ##
    # DSL methods (should probably be included)
    def values
      {"verbs": ["go", "do", "be"], "nouns": ["cats", "dogs"] }
    end

    # TODO add better pluralize
    def model_dir_name
      self.class.name.split("::").last.split(/(?=[A-Z])/).join("_").downcase.pluralize
    end

    def table_name
      "Ariel"
    end

    def message
      "trying out metadata"
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