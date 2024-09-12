class Base
  def self.inherited(klass)
    klass.singleton_class.define_method(:model_dir_name) do
      klass.name.demodulize.downcase.pluralize
    end

    klass.singleton_class.define_method(:where) do
      klass.name.demodulize.downcase.pluralize
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
end