module Orm
  class Dsl
    class Interface
      ##
      # dependencies
      require "json"
      require "yaml"
      require 'active_support/inflector'

      DB_VERSION = "0.0.1"

      def initialize(model_instance:)
        @model_instance = model_instance
      end

      attr_reader :model_instance

      def self.list_all_tables(model_name:)
        Dir["./db/#{model_name}/*"].map { |path| path.split("/").last }
      end

      def self.load_all_tables(model_name:)
        model = "::#{model_name.singularize.titleize}".safe_constantize
        self.list_all_tables(model_name: model_name ).map do |table_name|
          model.new(:name => table_name).load
        end
      end

      # returns the parsed YAML of the record
      def find_table(filename: nil)
        YAML.load_file(load_path) if File.exist?(load_path)
      end

      def save(message)
        ensure_file_structure
        write_files(message)
      end

      def load
        if !File.exist?(load_path)
          puts "no files found for this dictionary"
          return
        end
        data = YAML.load_file("#{load_path}")
        set_attributes(data)
        model_instance
      end

      def load_backup(filename)
        filename = filename.is_a?(Integer) ? "#{filename}.yml" : filename
        filename = filename.split("/").last
        YAML.load_file("#{backup_path}/#{filename}")
      end
    private

      def set_attributes(data_hash)
        puts data_hash
        data_hash.keys.each do |key|
          model_instance.class.module_eval { attr_accessor key}
          model_instance.send("#{key}=", data_hash[key])
          model_instance.values = data_hash
        end
      end

      def ensure_file_structure
        create_db_dir
        create_model_dir
        create_table_dir
        create_backup_dir
      end


      ##
      # file paths

      def path_to_model_dir
        "./db/#{model_instance.model_dir_name}"
      end

      def path_to_table_dir
        "#{path_to_model_dir}/#{model_instance.name.downcase}"
      end

      def load_path
        "#{path_to_table_dir}/#{model_instance.name.downcase}.yml"
      end

      def backup_path
        "#{path_to_table_dir}/backups"
      end

      ##
      # file structure

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

      ##
      # I/O

      def write_files(message)
        headers = {
          "metadata" =>
            {
              :db_version => DB_VERSION,
            }
        }

        headers["metadata"].merge("message" => message) if message.present?

        # overwrite main file
        values = headers.merge model_instance.values
        File.open("#{path_to_table_dir}/#{model_instance.name}.yml", 'w') do |file|
          file.write(values.to_yaml)
        end

        # make backup
        digest = Time.now.to_i
        File.open("#{path_to_table_dir}/backups/#{digest}.yml", 'w') do |file|
          file.write(values.to_yaml)
        end

        find_table # return the table from memory.
      end
    end
  end
end

