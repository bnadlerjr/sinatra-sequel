# Sinatra Sequel Extension

![Build Status](https://github.com/bnadlerjr/sinatra-sequel/actions/workflows/main.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/75e09f25ee70d6858519/maintainability)](https://codeclimate.com/github/bnadlerjr/sinatra-sequel/maintainability)

[Sinatra](http://sinatrarb.com/) extension and Rake tasks for dealing with SQL databases using the [Sequel Gem](https://github.com/jeremyevans/sequel).

## Installation

Add this this gem and a Sequel database adapter to your Sinatra application's `Gemfile`:

```ruby
gem 'sinatra-sequel'
gem 'sqlite3' # or any other adapter you wish
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sinatra-sequel

## Usage
Sinatra Sequel is implemented as a [Sinatra Extension](http://sinatrarb.com/extensions-wild.html) and can be used with both classic and module applications. When the extension is registered by Sinatra, it attempts to automatically run any pending database migrations found in the `PROJECT_ROOT/db/migrate` folder.

### Classic Application Example

```ruby
require 'sinatra'
require 'sinatra-sequel'
require 'sqlite3'

set :database, ''

get '/' do
  # The Sinatra Sequel extension makes a `database` helper available.
  database[:users].all
end
```

### Modular Application Example

```ruby
require 'sinatra/base'
require 'sinatra-sequel'
require 'sqlite3'

class MyApp < Sinatra::Base
  register Sinatra::Sequel

  set :database, ''
  
  get '/' do
    # The Sinatra Sequel extension makes a `database` helper available.
    database[:users].all
  end
end
```

### Rake Tasks
TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bnadlerjr/sinatra-sequel.

## Resources

* [Source Code](https://github.com/bnadlerjr/sinatra-sequel)
* [Bug Tracking](https://github.com/bnadlerjr/sinatra-sequel/issues)
* [Discussion Forum](https://github.com/bnadlerjr/sinatra-sequel/discussions)
* [Contribution Guidelines](https://github.com/bnadlerjr/sinatra-sequel/blob/main/CONTRIBUTING.md)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
