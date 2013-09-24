# Bis

[![Gem Version](https://badge.fury.io/rb/bis.png)](http://badge.fury.io/rb/bis)
[![Build Status](https://travis-ci.org/fuadsaud/bis.png?branch=master)]
                (https://travis-ci.org/fuadsaud/bis)
[![Code Climate](https://codeclimate.com/github/fuadsaud/bis.png)]
                (https://codeclimate.com/github/fuadsaud/bis)


A pure ruby immutable bitset implementation.

## Installation

    $ gem install bis

## Usage

```ruby
bis = Bis.new(8)  #=> <<00000000>> 0
bis.set(3)        #=> <<00001000>> 8
bis.set(3).set(2) #=> <<00001100>> 12
bis2 = bis.set(3).set(2).clear(3) #=> <<00000100>> 4
bis3 = bis2 << 4  #=> <<01000000>> 64
bis3 + 1          #=> <<1000001>> 65
bis3.concat(10)   #=> <<010000001010>> 1034
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fuadsaud/bis/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

