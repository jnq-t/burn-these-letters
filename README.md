# Scramble
Scramble is an Interactive Ruby tool that generates semi-randomized text using only words and sentences from your input text. The tool suports default and custom groupings. 

Scramble generates a random enocoding of each token (word, sentance, other custom grouping) to another token in the text. You can think of this scrambling funciton as a "translation" into a randomly-generated pseudo-langue, where every word is changed but the structure of the text remains largely intact. 

You can control custom grouping with the Dictionary tool. You can save, update, and load Dictinoaries. Then all you have to do is make a Scramble, and apply the Dictionary! 

## Get Started 
- [download ruby](https://www.ruby-lang.org/en/documentation/installation/)
  - the download method i recomend is [installing homebrew](https://docs.brew.sh/Installation)
  - installing ruby with `brew install ruby` 
- [clone this repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
- navigate into the `burn-these-letters-code` directory you cloned and execute `ruby start`
  - this will kick off a ruby terminal! This is going to be where you do your scrambling :) 
- start your Scramble! 
```
scrambler = Scramble.new("YOUR TEXT GOES HERE")
```
- get scramblin! see the instructions below on how to use the interface

## Methods and Params 
### .by_word
- breaks up your input by word, leaving punctuation (mostly) in place, and scrambles everything else.
```
scramble = Scramble.new(:text => "Hello, world! Hello, moon! This is a longer sentence!")
scramble.by_word
```
  ```
  => "is, world! is, hello! this longer a sentence moon!"
  => "is, this! is, world! a sentence longer hello moon!"
  => "this, is! this, sentence! world longer a hello moon!"
  ```  

### .by_sentence
- breaks up your input by sentence (wherever it see's a `.`, `?`, `!`) and scrambles those.
```
scramble = Scramble.new("Hello, world! Hello, moon! This is a longer sentence!")
scramble.by_sentence
```
  ```
  => "hello, moon! hello, world!  this is a longer sentence!"
  => "this is a longer sentence!  hello, moon! hello, world!"
  => "this is a longer sentence! hello, world!  hello, moon!"
  ```
### Upload a text asset 
If you want to scramble a longer text without worything about copy/pasting it, you can simply copy it into the `burn-these-letters-code/text_assets` folder! 
```
cp ~/Documents/hello_world.txt text_assets/my_new_asset.txt
```

You can now initialize your scramble using the name of that asset! 
```
ruby start
irb(main):001:0> Scramble.new("my_new_asset.txt")
=> #<Scramble:0x51424203 @text="hello, world!\n">
```

### Dictionaries 
Dictionaries allow you to scramble your input by word, but adhering to the custom deifitions you've defined.

Let's make a new Dictionary
```
ruby start
new_dictionary = Dictionary.new(name: "my_first_dictionary") # it will make things simpler if you avoid white spaces in your dictionary names)
=> #<Dictionary:0x147e0734 @name="my_first_dictionary", @values={}>
```
We've made a dicitionary. It has a name "my_first_dictionary", but no definitions. Let's give it some! 
```
new_dictionary.set_definition!(greetings: "hello")
=> #<Dictionary:0x147e0734 @name="my_first_dictionary", @values={:greetings=>["hello"]}>
```
We can add definitions that have more than one value
```
new_dictionary.set_definition!(nouns: ["world", "moon"])
=> #<Dictionary:0x147e0734 @name="my_first_dictionary", @values={:greetings=>"hello", :nouns=>["world", "moon"]}>
```

We can add values to existing definitions! 
```
new_dictionary.add_to_definition(:nouns => "sentence")
=> #<Dictionary:0x147e0734 @name="my_first_dictionary", @values={:nouns=>["world", "moon", "sentence"]}>
```

We can also add definitions with mulit-word groupings
```
new_dictionary.set_definition!(custom_subgroup: "This is a longer")
=> #<Dictionary:0x147e0734 @name="my_first_dictionary", @values={:nouns=>["world", "moon", "sentence"], :greetings=>["hello"], :custom_subgroup=>["This is a longer"]}>
```
When you scramble, this longer group will be treated as one "word". 

### Saving your Dictionary! 
When you're ready to start using a dictionary, start by saving it. 
```
new_dictionary.save
=> {"metadata"=>{:db_version=>"0.0.1"}, :nouns=>["world", "moon", "sentence"]}
```
### Loading your Dictionary
Let's pretend we've logged off, and want to retrieve our work. Start by exiting the terminal `exit` 
Now let's start it back up and find our dictionary! Lets first see all the saved dictioanries. 
```
ruby start
Dictionary.all
=> [#<Dictionary:0x5773d271 @nouns=["world", "moon", "sentence"], @name="my_first_dictionary", @values={"metadata"=>{:db_version=>"0.0.1"}, :nouns=>["world", "moon", "sentence"]}, @metadata={:db_version=>"0.0.1"}>, #<Dictionary:0x11bfffb3 @name="elva", @values={"metadata"=>{:db_version=>"0.0.1"}, :nounds=>["hammy"]}, @metadata={:db_version=>"0.0.1"}, @nounds=["hammy"]>, #<Dictionary:0x184afb78 @name="foo", @values={"metadata"=>{:db_version=>"0.0.1"}}, @metadata={:db_version=>"0.0.1"}>]
```
You may notice I have some other dictioanries saved on my machine. It's a bit hard to parse all of that, so let's just get their names. 
```
Dictionary.list_all
=> ["my_first_dictionary", "elva", "foo"]
```
That's a bit easier to parse. Now let's load our dictionary back up. 
```
loaded_dictionary = Dictionary.load_by_name("my_first_dictionary")
```
now that we've saved and retrived our dictionary, let's get scrambling! 

### .by_dictionary(INSTANCE OF DICTIONARY)
Let's look at all the definitions we've added so far. 
```
loaded_dictionary.definitions
=> {:nouns=>["world", "moon", "sentence"], :greetings=>["hello"], :custom_subgroup=>["This is a longer"]}
```
Let's scramble a new text! It's important to note that dictionaries should contain AT LEAST all of the words that are in your text. Here's a little text that is made up only of words in our dictionary. 

```
text = "Hello, world! Hello, world! This is a longer sentence!"
```
Let's start up a new scramble with that text. 

```
scramble = Scramble.new(text)
```
We can now scramble that text by word, or sentence! 
```
scramble.by_word
=> "a, is! a, is! hello sentence longer this world!"

scramble.by_sentence
=> "hello, world! this is a longer sentence! hello, world!"
```
Now let's try scrambling it with our dictionary. 
```
scramble.by_dictionary(loaded_dictionary)
=> "hello, sentence!hello, sentence! this is a longer moon!"
scramble.by_dictionary(loaded_dictionary)
=> "hello, sentence!hello, sentence! this is a longer world!"
scramble.by_dictionary(loaded_dictionary)
=> "hello, moon!hello, moon! this is a longer sentence!"
```
The first thing you'll probably notice is the bad formatting (it's a WIP). 
You may also notice that even though our text didn't contain the word "moon", because the dictionary knows that `sentence` `moon` and `world` are in a subgroup, it randomizes between them. 
You may also notice that `This is a longer` never moves. This is because the subgroup of `This is a longer` contains only itself. If you want a word or phrase to never change, you can include it in a subgroup by itself. 

Congratulations! You've scrambled using a custom dictionary! 

### Dictionary ORM methods 

`Dictionary.all` loads all dictioanries in the DB 

`Dictionary.list_all` pulls all the dictionary names in the DB 

`Dictionary.by_definition_key` loads all dictionaries that contain the given definition key (i.e. "nouns") 

`Dictioanry.by_definition_value` loads all dictionaries that contain the given definition value (i.e. "moon")

`Dictionary.where()` returns all dictioanries that exactly match the expression. For example `Dictionary.where(greetings: "hello") would load our dictioanry, while `Dictioanry.where(nouns: "moon")` would not

`Dcitionary.where_any()` returns all dictionaries that match the expression, inlcuding incomplete matches. In this case `Dictionary.where(nouns: "moon")` would indeed find our dictionary

`Dictionary.first` loads the first dictioanry in the db 

