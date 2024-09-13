require_relative 'base'
class Result < Base
  # belongs_to scramble
  def initialize(name:)
    super(name: name)
  end

  attr_accessor :result, :scramble_instance


  def scramble_instance
    @scramble_instance = Scramble.load_by_name @name
  end

  def belongs_to
    scramble_instance.name
  end
  alias_method :name, :belongs_to

  def record(n:1, by: "word")
    n.times do
      result = scramble_instance.public_send "by_#{by}".to_sym
      self.new(:name => belongs_to).result=result.save
    end
  end

  def result=(result)
    @result ||= result
  end

  def values
    @values ||=
      {
        :belongs_to => belongs_to,
        :result => @result
      }
  end

  ##
  # TODO overload
  def self.load_by_name(name)
    self.where(:name => name).first
  end
end