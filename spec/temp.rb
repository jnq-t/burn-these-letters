# test scripts

##
# testing load functionality

# CASE test for dirty values
dict = Models::Dictionary.new(:name => "elva")
dict.values[:foo] = ["bar"]
dict.load


