# Wisper::Activejob::Broadcaster

> Publish wisper events with activejob

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wisper-activejob-broadcaster'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wisper-activejob-broadcaster

## Usage

```ruby
class MyListener < ApplicationJob
  # configure listener to act as background job
  include Wisper::ActiveJob::Subscriber

  # define any event listeners here
  def my_event
  end
end

Wisper.subscribe(MyListener.new, broadcaster: Wisper::Broadcasters::ActiveJobBroadcaster.new)
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/wisper-activejob-broadcaster.

