require_relative 'base'

class Scramble < Base
  def initialize(text: "", name:)
    @text = text
    @name = name
    check_for_asset
  end

  attr_reader :text, :name

  def by_dictionary(dictionary)
    groupings = dictionary.definitions.reduce([]) do |acc,(_,v)|
      acc << v
      acc
    end

    by_custom_subgroup(groupings: groupings)
  end

  def by_sentence
    delimiters = [".","!","?"]
    words_and_punctuation = text.split(/(\.|\?|!)/)
    words = words_and_punctuation.reject { |word| delimiters.include?(word) }
    map = make_map(words)
    apply_map(map, words_and_punctuation)
  end

  def by_word
    words = get_words_with_punctuation
    unique = words.uniq.reject do |str|
      str.match?(/[^a-zA-Z0-9]/) # excludes non-alphanumeric characters from the map
    end
    map = make_map(unique)
    apply_map(map,words)
  end

  def values
    {
      :text => @text
    }
  end

  def values=(data_hash)
    @text = data_hash[:text]
  end

  def results
  end

private

  ##
  # initialization

  def check_for_asset
    return unless @text.present?

    asset_path ="text_assets/#{@text}"
    @text = File.read(asset_path) if File.exists?(asset_path)
  end

  # helper methods
  #
  # creates a random mapping of each word in the list to another word in the list
  def make_map(unique_words)
    shuffled = unique_words.shuffle
    unique_words.each_with_index.reduce({}) { |acc, (w, i)| acc[w] = shuffled[i]; acc}
  end

  # iterates through the list of words and transforms them into their randomly mapped counterpart
  # TODO ensure an intermediate state
  def apply_map(map, words)
    applied = words.reduce([]) do |acc, word|
      map_value = map[word]
      acc << (!map_value.nil? ? map_value : word).downcase
      acc
    end
    binding.pry
    applied.join(" ")
  end

  def by_custom_subgroup(groupings: [])
    substrings = groupings.select { |a| a.first.split(" ").length > 1 }.flatten
    words = get_words_with_punctuation(substrings: substrings)
    map = arrays_to_map(groupings)
    apply_map(map,words)
  end


  # takes a list of lists, maps each one on istself, and then compbines them into one big map
  # the idea is that you can pass in lists that represent "subgroupings", like words grouped by their
  #parts of speech, and the output map will "respect" the sub-groupings
  def arrays_to_map(arrays)
    arr_of_hashes = arrays.map { |a| make_map(a)}.flatten
    arr_of_hashes.reduce({},:merge)
  end

  def get_words_with_punctuation(substrings: [])
    # regex = Regexp.new("#{substring_exp(substrings)}([\\w'-]+|[[:punct:]]+)")
    word_pattern = '[\\w\'-]+'
    punctuation_pattern = '[[:punct:]]+'

    regex = Regexp.new("#{substring_exp(substrings)}(#{word_pattern}|#{punctuation_pattern})")

    text.scan(regex).map(&:compact).flatten
  end

  def substring_exp(substrings_array)
    return "" if substrings_array.empty?

    sorted_substrings = substrings_array.sort_by(&:length).reverse
    # Create a regex pattern that matches any of the substrings or the original tokenization
    substring = sorted_substrings.map { |s| Regexp.escape(s) }.join('|')
    "(#{substring})|"
  end
end