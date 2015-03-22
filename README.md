# Jewelpod

Gem server for in-house gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jewelpod'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jewelpod

## Usage

```
% jewelpod --storage-url file:///var/lib/jewelpod
```

```
% AWS_ACCESS_KEY_ID=AKIAXXXXXXXX AWS_SECRET_ACCESS_KEY=YYYYYYY AWS_REGION=ap-northeast-1 jewelpod --storage-url s3://your.bucket.name/jewelpod
```

You can also run Jewelpod server as a Rack application.

```
% cat config.ru
require 'jewelpod/server'

Jewelpod.config.storage_url = 's3://your.bucket.name/jewelpod'
run Jewelpod::Server
% rackup -E production -p 3000
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/eagletmt/jewelpod/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
