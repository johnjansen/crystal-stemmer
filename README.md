# crystal-stemmer

[![GitHub version](https://badge.fury.io/gh/johnjansen%2Fcrystal-stemmer.svg)](http://badge.fury.io/gh/johnjansen%2Fcrystal-stemmer)
[![CI](https://travis-ci.org/johnjansen/crystal-stemmer.svg?branch=master)](https://travis-ci.org/johnjansen/crystal-stemmer)

A port of a [Ruby Stemmify](https://github.com/raypereda/stemmify) to crystal

This is a crystal shard for reducing words to their roots. For example, all the
following words to are stemmed to "observ", which is not a real word
in this case:
```
observance
observances
observancy
observant
observants
observation
observe
observed
observer
observers
observing
observingly
```

The algorithm used here is based on the Porter stemmer.
You can read more about Martin Porter's stemmer at 

http://tartarus.org/~martin/PorterStemmer/

Martin Porter explains:

```
The Porter stemming algorithm (or ‘Porter stemmer’) is a process for removing
the commoner morphological and inflexional endings from words in English. Its
main use is as part of a term normalisation process that is usually done when
setting up Information Retrieval systems.
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  stemmer:
    github: johnjansen/crystal-stemmer
```


## Usage

Let's say you are building some sort of search tool. You want
searches for "observations" and "observer" to all bring up
the same items. When you are building you index, you can
map all the words to their roots using the stem method.

Here's an example usage:

```
require 'stemmer'
print("observations".stem) # ==> "observ"
```

## Test Suite

This test is based on the sample input and output text from Martin Porter
website. It includes 23532 test words and their expected stem results.
To run the test, just type

```
crystal spec
```

## Contributing

1. Fork it ( https://github.com/johnjansen/stemmer/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [johnjansen](https://github.com/johnjansen) John Jansen - creator, maintainer
