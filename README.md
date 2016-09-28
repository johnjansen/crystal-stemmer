# stemmer

A very quick and dirty port of a Porter Stemmer
essentially copied from https://github.com/raypereda/stemmify/blob/master/lib/stemmify.rb
and crystalized (kind of)

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  stemmer:
    github: johnjansen/crystal-stemmer
```


## Usage


```crystal
require "stemmer"

"Classified".stem # => Classifi
"Classify".stem   # => Classifi
```

## Contributing

1. Fork it ( https://github.com/[your-github-name]/stemmer/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [johnjansen](https://github.com/johnjansen) John Jansen - creator, maintainer
