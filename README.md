# Scrambler 
The scrambler is an Interactive Ruby tool that generates semi-randomized text using only words and sentences from your input text. The tool suports default and custom groupings. 

## Get Started 
- [download ruby](https://www.ruby-lang.org/en/documentation/installation/)
- [clone this repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
- navigate to the directory your cloned this project into and exectute `irb -r ./lib/scrambler.rb`
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
- breaks up your input by word, leaving punctuation (mostly) in place, and scrambles everything else. It'll need some formatting. 
```
scrambler.scramble(:text => "Hello, world! Hello, moon! This is a longer sentence!")
=> "world , a ! world , Hello ! moon is longer This sentence !"
=> "sentence , a ! sentence , moon ! This world longer Hello is !"
=> "is , sentence ! is , a ! This moon world longer Hello !
```

### .scramble.by_sentence(:text => YOUR INPUT TEXT)
- breaks up your input by sentence (wherever it see's a `.`, `?`, `!`) and scrambles those.
```
scrambler.scramble.by_sentence(ç)
=> "Hello, world !  Hello, moon !  This is a longer sentence !"
=> " Hello, moon ! Hello, world !  This is a longer sentence !"
=> "Hello, world !  This is a longer sentence !  Hello, moon !"
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
=> "Hello , world ! Hello , sentence ! This is a longer moon !"
=> "Hello , moon ! Hello , world ! This is a longer sentence !"
=> "Hello , world ! Hello , moon ! This is a longer sentence !"
```

# WIP 
- scramble.by_part_of_speech is coming as soon as I get the [OED API](https://developer.oxforddictionaries.com/documentation) hooked up.
- CLI tools when I get around to it.
