# lita-redis-subscribe

Bootup with chatroom.

say `subscribe KEY`

Connecting and subscribe to redis.
Channel key => [prefix, KEY, suffix] join to sep_str.

## Installation

Add lita-redis-subscribe to your Lita instance's Gemfile:

``` ruby
gem "lita-redis-subscribe"
```

## Configuration

``` ruby
Lita.configure do |config|
  config.handlers.redis_subscribe.host = "your_redis_host"
  config.handlers.redis_subscribe.port = "your_redis_port"
  config.handlers.redis_subscribe.prefix = "prefix"
  config.handlers.redis_subscribe.suffix = "suffix"
  config.handlers.redis_subscribe.sep_str = "."
end
```

## Usage

TODO: Describe the plugin's features and how to use them.

## License

[MIT](http://opensource.org/licenses/MIT)