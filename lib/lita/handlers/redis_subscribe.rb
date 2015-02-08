# -*- coding: utf-8 -*-
module Lita
  module Handlers
    class RedisSubscribe < Handler

      config :host,    type: String
      config :port,    type: Integer
      config :prefix,  type: String
      config :suffix,  type: String
      config :sep_str, type: String

      on :connected, :delete_all_keys

      route(/^subscribe\s+(.+)$/, :subscribe, help: { "subscribe CHANNEL" => "Starting redis subscribe." })

      def subscribe(response)
        subscribe_key = subscribe_key_gen(response.matches.first)
        redis_key = redis_key_gen(subscribe_key, response.message.source.room)
        if redis.get(redis_key)
          response.reply("Im working! ヽ(｀Д´#)ﾉ")
          return
        end
        redis.set(redis_key, true)
        every(0) do |timer|
          begin
            response.reply("connect to [#{subscribe_key}] ...")
            redis_client = Redis.new(host: config.host, port: config.port)
            response.reply("complete.")
            redis_client.subscribe(subscribe_key) do |on|
              on.message do |ch, msg|
                post = JSON.parse(msg)
                body = post['message'] or next
                response.reply(body)
              end
            end
          rescue
            sleep 1
            retry
          end
        end
      end

      def delete_all_keys(payload = nil)
        redis.keys("*#{redis_key_gen}*").map {|k| redis.del(k)}
      end

      def subscribe_key_gen(channel_key = nil)
        keys = []
        keys << config.prefix if config.prefix
        keys << channel_key   if channel_key
        keys << config.suffix if config.suffix
        return if keys.size == 0
        keys.join config.sep_str
      end

      def redis_key_gen(subscribe_key = nil, room_id = nil)
        keys = []
        keys << subscribe_key if subscribe_key
        keys << self.class.to_s
        keys << room_id if room_id
        keys.join ?:
      end

    end

    Lita.register_handler(RedisSubscribe)
  end
end
