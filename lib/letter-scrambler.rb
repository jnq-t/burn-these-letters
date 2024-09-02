class LetterScrambler
  # API ID [String] (Your API ID to the Oxford English Dictionary API )
  # API KEY [String] (Your API ID to the Oxford English Dictionary API)
  ## https://developer.oxforddictionaries.com/documentation/getting_started

  def initialize(api_id:, api_key:)
    @api_id = api_id
    @api_key = api_key
  end

# params Text [String] (the complete text you wish to scramble)
# params Subgrouped Array [Array of Arrays] (if you wish to include a subgrouping that's
  def scramble(text: "")
    if text.empty?
      interface_with_options
    else
      general_scramble([], text)
    end
  end

private
  # not built into the options, that mapping goes here)
  # we actually don't need these options, but maybe
  # i'll want to use them eventually
  # def interface_with_options
  #   def words
  #     scrambler_interface(:words)
  #   end
  #   def sentences
  #     scrambler_interface(:sentences)
  #   end
  # end

  def scrambler_interface
    Class.new do
      def by_part_of_speech(text)
        scramble_by_part_of_speech(text)
      end

      def by_custom_subgroup(text:, subgrouped_array: {})
        scramble_by_custom_subgroup(text, subgrouped_array)
      end
    end
  end

  def scramble_by_part_of_speech(text)
    puts "breaking parts of speech: #{text}: stub"
    text.split(" ")
  end

  def scramble_by_custom_subgroup(text:, subgrouped_array: {})
    "subgorup #{text} : #{subgrouped_array}"
  end

  def scramble_by_sentance(text)
    puts "sentance: #{text}"
  end

  def general_scramble(arrays, words)
    map = arrays_to_map(arrays)
    applied = apply_map(map, words)
    applied.join(' ')
  end

  # helper methods
  #
  # creates a random mapping of each word in the list to another word in the list
  def make_map(words)
     unique = words.uniq.reject do |str|
      str.match?(/[^a-zA-Z0-9]/) # excludes non-alphanumeric characters from the map
    end
     shuffled = unique.shuffle
     unique.each_with_index.reduce({}) { |acc, (w, i)| acc[w] = shuffled[i]; acc}
  end

  # iterates through the list of words and transforms them into their randomly mapped counterpart
  def apply_map(map, words)
    words.reduce([]) do |acc, word|
      map_value = map[word]
      acc << (map_value.present? ? map_value : word)
      acc
    end
  end

  # takes a list of lists, maps each one on istself, and then compbines them into one big map
  # the idea is that you can pass in lists that represent "subgroupings", like words grouped by their
  #parts of speech, and the output map will "respect" the sub-groupings
  def arrays_to_map(arrays)
    arr_of_hashes = arrays.map { |a| make_map(a)}.flatten
    arr_of_hashes.reduce({},:merge)
  end
end