class Scrambler
  def initialize(text: "")
    @text = text
  end

  attr_reader :text

# params Text [String] (the complete text you wish to scramble)
  def scramble
    scrambler_interface
  end

  class Interface
    def initialize(scrambler)
      @scrambler = scrambler
    end

    def by_word
      @scrambler.send(:scramble_by_word)
    end

    def by_dictionary(groupings:)
      @scrambler.send(:scramble_by_custom_subgroup, groupings: groupings)
    end

    def by_sentence
      @scrambler.send(:scramble_by_sentence)
    end
  end

  def scrambler_interface
    Interface.new(self)
  end

  def scramble_by_custom_subgroup(groupings: [])
    substrings = groupings.select { |a| a.first.split(" ").length > 1 }.flatten
    words = get_words_with_punctuation(substrings: substrings)
    map = arrays_to_map(groupings)
    apply_map(map,words)
  end

  def scramble_by_sentence
    delimiters = [".","!","?"]
    words_and_punctuation = text.split(/(\.|\?|!)/)
    words = words_and_punctuation.reject { |word| delimiters.include?(word) }
    map = make_map(words)
    apply_map(map, words_and_punctuation)
  end

  def scramble_by_word
    words = get_words_with_punctuation
    unique = words.uniq.reject do |str|
      str.match?(/[^a-zA-Z0-9]/) # excludes non-alphanumeric characters from the map
    end
    map = make_map(unique)
    apply_map(map,words)
  end

  # helper methods
  #
  # creates a random mapping of each word in the list to another word in the list
  def make_map(unique_words)
    shuffled = unique_words.shuffle
    unique_words.each_with_index.reduce({}) { |acc, (w, i)| acc[w] = shuffled[i]; acc}
  end

  # iterates through the list of words and transforms them into their randomly mapped counterpart
  def apply_map(map, words)
    applied = words.reduce([]) do |acc, word|
      map_value = map[word]
      acc << (!map_value.nil? ? " " + map_value : word).downcase
      acc
    end
    applied.join.lstrip.gsub("  ", " ") # some whitespace handling
  end

  # takes a list of lists, maps each one on istself, and then compbines them into one big map
  # the idea is that you can pass in lists that represent "subgroupings", like words grouped by their
  #parts of speech, and the output map will "respect" the sub-groupings
  def arrays_to_map(arrays)
    arr_of_hashes = arrays.map { |a| make_map(a)}.flatten
    arr_of_hashes.reduce({},:merge)
  end

  def get_words_with_punctuation(substrings: [])
    regex = Regexp.new("#{substring_exp(substrings)}([\\w'-]+|[[:punct:]]+)")
    text.scan(regex).map(&:compact).flatten
  end
end

def substring_exp(substrings_array)
  return "" if substrings_array.empty?

  sorted_substrings = substrings_array.sort_by(&:length).reverse
  # Create a regex pattern that matches any of the substrings or the original tokenization
  substring = sorted_substrings.map { |s| Regexp.escape(s) }.join('|')
  "(#{substring})|"
end