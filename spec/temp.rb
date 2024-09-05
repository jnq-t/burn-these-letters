# test scripts
require "../orm/dsl.rb"

##
# testing load functionality

# CASE test for dirty values
dict = Models::Dictionary.new(:name => "elva", :values => {"default" => ["blah"]})
dict.set_definition!(:foo, ["bar","baz","fiz"])
dict.load

# CASE load backup
# COMMAND LINE
irb -r "./models/dictionary.rb"
# IRB

dict = Models::Dictionary.new(:name => "elva")
filename = 1725551720
dict.load_backup(filename: filename)

# CASE add value and save
dict = Models::Dictionary.new(:name => "elva")
dict.add_definition(:foo, ["bar","baz","fiz"])
dict.save