# Scrambler 
The scrambler is an Interactive Ruby tool that generates semi-randomized text using only words and sentences from your input text. The tool suports default and custom groupings. 

The scrambler generates a random enocoding of each token (word, sentance, other custom grouping) to another token in the text. You can think of this scrambling funciton as a "translation" into a randomly-generated pseudo-langue, where every word is changed but the structure of the text remains largely intact. 

## Get Started 
- [download ruby](https://www.ruby-lang.org/en/documentation/installation/)
- [clone this repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
- navigate into the `burn-these-letters-code` directory you cloned and exectute `irb -r ./lib/scrambler.rb`
- Initialize the scrambler
```
scrambler = Scrambler.new
```
- get scramblin! here's how to strucutre your call
```
'scrambler.scramble(:text => INPUT_TEXT)
```
## Methods and Params 
### .scramble(:text => YOUR INPUT TEXT)
- breaks up your input by word, leaving punctuation (mostly) in place, and scrambles everything else.
```
scrambler.scramble(:text => "Hello, world! Hello, moon! This is a longer sentence!")
=> "is, world! is, hello! this longer a sentence moon!"
=> "is, this! is, world! a sentence longer hello moon!"
=> "this, is! this, sentence! world longer a hello moon!"
```

### .scramble.by_sentence(:text => YOUR INPUT TEXT)
- breaks up your input by sentence (wherever it see's a `.`, `?`, `!`) and scrambles those.
```
scrambler.scramble.by_sentence(:text => "Hello, world! Hello, moon! This is a longer sentence!")
=> "hello, moon! hello, world!  this is a longer sentence!"
=> "this is a longer sentence!  hello, moon! hello, world!"
=> "this is a longer sentence! hello, world!  hello, moon!"

```
### .scramble.by_custom_subgroup(:text => YOUR INPUT TEXT, :subgrouped_array => [Array of [Sub Arrays]) 
- scrambles your input by word, but adhering to what ever custom grouping you passed in.
```
groupings = [
  ["Hello"], # greetings
  ["world", "moon", "sentence"], # nouns
  ["This is a longer"] # custom phrase you want to keep intact 
]
scrambler.scramble.by_custom_subgroup(:text => "Hello, world! Hello, moon! This is a longer sentence!", :subgrouped_array => groupings)
=> " hello, moon! hello, sentence! this is a longer world!"
=> " hello, world! hello, moon! this is a longer sentence!"
=> " hello, moon! hello, world! this is a longer sentence!"

```

# WIP 
- scramble.by_part_of_speech is coming as soon as I get the [OED API](https://developer.oxforddictionaries.com/documentation) hooked up.
- CLI tools when I get around to it.
