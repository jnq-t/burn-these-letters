require_relative 'base'
class Result < Base
  require 'pry'
  # belongs_to scramble
  def initialize(name:, result: "")
    @result = result
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
    raise "No associated scramble found" unless scramble_instance
    n.times.with_index do |i|
      result = scramble_instance.public_send "by_#{by}".to_sym
      self.class.new(:name => belongs_to, :result => result).save_multiples(postfix: i)
    end
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