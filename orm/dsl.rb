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

      def message
        "trying out metadata"
      end
    end

    def initialize(model_instance: GenericModel.new)
      @model_instance = model_instance
    end

    attr_reader :model_instance

    def save
      ensure_file_structure
      write_hash_to_file
    end

  # private

    def ensure_file_structure
      create_db_dir
      create_model_dir
      create_table_dir
      create_backup_dir
    end

    def create_db_dir
      Dir.mkdir("./db") unless Dir.exist?("./db")
    end

    def create_model_dir
      Dir.mkdir(path_to_model_dir) unless Dir.exist?(path_to_model_dir)
    end
    
    def create_table_dir
      Dir.mkdir(path_to_table_dir) unless Dir.exist?(path_to_table_dir)
    end
    
    def create_backup_dir
      path = "#{path_to_table_dir}/backups"
      Dir.mkdir(path) unless Dir.exist?(path)
    end
    
    def path_to_model_dir
      "./db/#{model_instance.model_dir_name}"
    end

    def path_to_table_dir
      "#{path_to_model_dir}/#{model_instance.table_name.downcase}"
    end

    # should maybe just make a new file each change. then we basically get version control for free.
    def write_hash_to_file
      headers = {
        "metadata" =>
          {
            :db_version => DB_VERSION,
            :message => model_instance.message
          }
      }
      # overwrite main file
      values = headers.merge model_instance.values
      File.open("#{path_to_table_dir}.yml", 'w') do |file|
        file.write(values.to_yaml)
      end

      # make backup
      # TODO add a check here to see if the file is literally identical, and if so to not make another backup
      digest = Time.now.to_i
      File.open("#{path_to_table_dir}/backups/#{digest}.yml", 'w') do |file|
        file.write(values.to_yaml)
      end
    end
  end
end

