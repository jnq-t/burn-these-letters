


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

# creates the map and applies the mapping 
def new_letter(words)
  map = make_map(words)
  applied = apply_map(map,words)
  applied.join(" ")
end

# TODO arrays = [TELL AN LLM TO BREAK YOUR TEXT INTO AN ARRAY OF ARRAYS GROUPED BY PARTS OF SPEECH]
# the array sound look something like this:

#arrays = [["the","this"],["cats,"dogs"],["go","gone"]] 

# takes a list of lists, maps each one on istself, and then compbines them into one big map
# the idea is that you can pass in lists that represent "subgroupings", like words grouped by their 
#parts of speech, and the output map will "respect" the sub-groupings
def arrays_to_map(arrays)
  arr_of_hashes = arrays.map { |a| make_map(a)}.flatten
  arr_of_hashes.reduce({},:merge)
end

# uses the sub-list approach to generate a new letter
def sub_list_letter(arrays,words)
  map = arrays_to_map(arrays)
  applied = apply_map(map,words)
  applied.join(" ")
end
