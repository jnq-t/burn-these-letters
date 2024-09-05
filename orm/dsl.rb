module Orm
  class Dsl
    require "json"
    require "yaml"

    DB_VERSION = "0.0.1"

    class GenericModel
      def values
        {"verbs": ["go", "do", "be"], "nouns": ["cats", "dogs"] }
      end

      # TODO add better pluralize
      def model_dir_name
        self.class.name.split("::").last.split(/(?=[A-Z])/).join("_").downcase + "s"
      end

      def table_name
        "Ariel"
      end
    end

    def initialize(model_instance: GenericModel.new)
      @model_instance = model_instance
    end

    attr_reader :model_instance

    def save
      model_instance.values.to_json
      ensure_file_structure
    end

  private

    def ensure_file_structure
      create_db_directory
      create_model_directory
      write_hash_to_file
    end

    def create_db_directory
      Dir.mkdir("./db") unless Dir.exist?("./db")
    end

    def create_model_directory
      Dir.mkdir("./db/#{model_instance.model_dir_name}") unless Dir.exist?("./db/#{model_instance.model_dir_name}")
    end

    def path_to_table
      "./db/#{model_instance.model_dir_name}/#{model_instance.table_name}.yml"
    end

    def write_hash_to_file
      values = {:db_version => DB_VERSION}.merge model_instance.values
      File.open(path_to_table, 'w') do |file|
        file.write(values.to_yaml)
      end
    end
  end
end

