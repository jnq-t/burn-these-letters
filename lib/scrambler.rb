class Scrambler
  # require "../helpers/oed_api_wrapper"

  # API ID [String] (Your API ID to the Oxford English Dictionary API )
  # API KEY [String] (Your API ID to the Oxford English Dictionary API)
  ## https://developer.oxforddictionaries.com/documentation/getting_started

  def initialize(api_id: nil, api_key: nil)
    @api_id = api_id
    @api_key = api_key
  end

  attr_reader :api_id, :api_key

# params Text [String] (the complete text you wish to scramble)
# params Subgrouped Array [Array of Arrays] (if you wish to include a subgrouping that's
  def scramble(text: "")
    if text.empty?
      scrambler_interface
    else
      words = text.split(" ")
      map = make_map(words)
      apply_map(map, words)
    end
  end

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

  class Interface
    def initialize(scrambler)
      @scrambler = scrambler
    end

    def by_part_of_speech(text:)
      if @scrambler.api_id.nil? || @scrambler.api_key.nil?
        puts "you must provide OED Credentials to use the part of speech option"
        return
      end

      @scrambler.send(:scramble_by_part_of_speech, text: text)
    end

    def by_custom_subgroup(text:, subgrouped_array:)
      @scrambler.send(:scramble_by_custom_subgroup, text: text, subgrouped_array: subgrouped_array)
    end

    def by_sentence(text:)
      @scrambler.send(:scramble_by_sentence, text: text)
    end
  end

  def scrambler_interface
    Interface.new(self)
  end

  def scramble_by_part_of_speech(text)
    # TODO
    # words = text.split(" ").select { |str| alphanumeric?(str) }

    puts "this is still WIP. Until it's ready you can enter your own sorted list by parts of speech using the .by_custom_subgroup method"
  end

  def scramble_by_custom_subgroup(text:, subgrouped_array: [])
    words = text.split(" ")
    map = arrays_to_map(subgrouped_array)
    apply_map(map,words)
  end

  def scramble_by_sentence(text:)
    words = text.split(".")
    map = shuffle_and_map(words)
    apply_map(map, words)
  end

  # helper methods
  #
  # creates a random mapping of each word in the list to another word in the list
  def make_map(words)
    unique = words.uniq.reject do |str|
      str.match?(/[^a-zA-Z0-9]/) # excludes non-alphanumeric characters from the map
    end
     shuffle_and_map(unique)
  end

  def shuffle_and_map(unique_word_array)
    shuffled = unique_word_array.shuffle
    unique_word_array.each_with_index.reduce({}) { |acc, (w, i)| acc[w] = shuffled[i]; acc}
  end

  # iterates through the list of words and transforms them into their randomly mapped counterpart
  def apply_map(map, words)
    applied =words.reduce([]) do |acc, word|
      map_value = map[word]
      acc << (!map_value.nil? ? map_value : word)
      acc
    end
    applied.join(' ')
  end

  # takes a list of lists, maps each one on istself, and then compbines them into one big map
  # the idea is that you can pass in lists that represent "subgroupings", like words grouped by their
  #parts of speech, and the output map will "respect" the sub-groupings
  def arrays_to_map(arrays)
    arr_of_hashes = arrays.map { |a| make_map(a)}.flatten
    arr_of_hashes.reduce({},:merge)
  end
end