class Base
  require_relative '../orm/dsl'
  def self.inherited(klass)
    klass.singleton_class.define_method(:model_dir_name) do
      klass.name.demodulize.downcase.pluralize
    end

    klass.instance_eval do
    ::Orm::Dsl::Interface.new(:model_instance => self)
    end
  end

  def self.model_dir_name
    raise "Not Implemented"
  end


  def self.where(expression)
    ::Orm::Dsl::Interface.where(expression: expression, :model_name => self.model_dir_name)
  end

  def self.load_by_name(name)
    self.where(:name => name).first
  end

  def self.where_any(expression)
    ::Orm::Dsl::Interface.where_any(expression: expression, :model_name => self.model_dir_name)
  end

  def self.list_all
    ::Orm::Dsl::Interface.list_all_tables(:model_name => self.model_dir_name)
  end

  def self.all
    ::Orm::Dsl::Interface.load_all_tables(:model_name => self.model_dir_name)
  end

  def self.first
    self.all.first
  end

  ##
  # loads the latest
  def load
    interface.load
  end

  ##
  # loads a specific backup
  def load_backup(filename)
    interface.load_backup(filename)
  end

  ##
  # saves the current state
  # param Message (message metadata for your dictionary. Think of this like a commit message)
  def save(message: "")
    interface.save(message)
  end

  def interface
    ::Orm::Dsl::Interface.new(:model_instance => self)
  end
end