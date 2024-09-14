module Orm
  class Dsl
    class Interface
      ##
      # dependencies
      require "json"
      require "yaml"
      require "pry"
      require 'active_support/inflector'

      DB_VERSION = "0.0.1"

      def initialize(model_instance:)
        @model_instance = model_instance
      end

      attr_reader :model_instance

      # keys and values must match exactly(though key order doesn't matter)
      def self.where(expression:, model_name:)
        values = expression.values.first # DRY this up by abstracting the shared logic between this and where any
        keys = expression.keys.first
        self.load_all_tables(:model_name => model_name).select do |instance|
          instance.values.select { |k,v| k == keys && v.sort == values.sort }.any? ||
            (keys.to_sym == :name && values == instance.name)
        end
      end

      # returns any record with a a matching key-value pair
      def self.where_any(expression:, model_name:)
        values = expression.values.first
        values = values.is_a?(Array) ? values : [values]
        keys = expression.keys.first

        self.load_all_tables(:model_name => model_name).select do |instance|
          instance.values.select do |k,v|
            k == keys &&
            v - values != v # finds any overlapping values
          end.any?
        end
      end

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

      def save_multiples(postfix)
        ensure_file_structure
        create_aggregate_save_dir
        write_aggregate(postfix)
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
        "./db/#{model_instance.class.model_dir_name}"
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

      def path_to_aggregate_save_dir
        @path_to_aggregate_save_dir ||= "#{path_to_table_dir}/#{Time.now.to_s.split.first}"
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

      ##
      # idea for multiple aggregate records on the same day, still buggy
      #
      def create_aggregate_save_dir
        Dir.mkdir(path_to_aggregate_save_dir) unless Dir.exist?(path_to_aggregate_save_dir)
        make_time_stamp_records_dir
      end

      def make_time_stamp_records_dir
        time = Time.now.to_s.split[1]
        @path_to_aggregate_save_dir += "/" + time
        Dir.mkdir(path_to_aggregate_save_dir) unless Dir.exist?(path_to_aggregate_save_dir)
      end

      def create_backup_dir
        path = "#{path_to_table_dir}/backups"
        Dir.mkdir(path) unless Dir.exist?(path)
      end

      def build_save_headers(message)
        headers = {
          "metadata" =>
            {
              :db_version => DB_VERSION,
            }
        }

        headers["metadata"].merge("message" => message) if message.present?

        # overwrite main file
        headers
      end

      ##
      # I/O

      def write_files(message)
        filename = model_instance.name
        values = build_save_headers(message).merge model_instance.values

        File.open("#{path_to_table_dir}/#{filename}.yml", 'w') do |file|
          file.write(values.to_yaml)
        end

        # make backup
        digest = Time.now.to_i
        File.open("#{path_to_table_dir}/backups/#{digest}.yml", 'w') do |file|
          file.write(values.to_yaml)
        end

        find_table # return the table from memory.
      end

      def write_aggregate(postfix)
        values = build_save_headers("").merge model_instance.values
        filename = "#{model_instance.name}(#{postfix})"

        write_path = "#{path_to_aggregate_save_dir}/#{filename}"
        File.open("#{write_path}.yml", 'w') do |file|
          file.write(values.to_yaml)
        end
      end
    end
  end
end

