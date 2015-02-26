# -*- coding: utf-8 -*-
module Lita
  module Handlers
    class RedisSubscribe < Handler

      config :host,    type: String
      config :port,    type: Integer
      config :prefix,  type: String
      config :suffix,  type: String
      config :sep_str, type: String
      config :auto_connects, type: Hash

      on(:connected) do |payload|
        delete_all_keys
        if config.auto_connects
          config.auto_connects.each do |room_id, key|
            target = Lita::Source.new(room: room_id)
            subscribe_key = subscribe_key_gen(key)
            redis_key = redis_key_gen(subscribe_key, target.room)
            do_subscribe(subscribe_key, redis_key, {:target => target})
          end
        end
      end

      route(/^subscribe\s+(.+)$/, :subscribe, help: { "subscribe CHANNEL" => "Starting redis subscribe." })

      def subscribe(response)
        subscribe_key = subscribe_key_gen(response.matches.first)
        redis_key = redis_key_gen(subscribe_key, response.message.source.room)
        do_subscribe(subscribe_key, redis_key, {:response => response})
      end

      def do_subscribe(subscribe_key, redis_key, opt)
        if redis.get(redis_key)
          do_send_message("Im working! ヽ(｀Д´#)ﾉ", opt)
          return
        end
        redis.set(redis_key, true)
        every(0) do |timer|
          begin
            do_send_message("connect to redis ...", opt)
            redis_client = Redis.new(host: config.host, port: config.port)
            do_send_message("connected.", opt)
            redis_client.subscribe(subscribe_key) do |on|
              on.message do |ch, msg|
                post = JSON.parse(msg)
                body = post['message'] or next
                do_send_message(body, opt)
              end
            end
          rescue
            sleep 1
            retry
          end
        end
      end

      def do_send_message(text, opt)
        if opt.has_key? :target
          robot.send_message(opt[:target], text)
        elsif opt.has_key? :response
          opt[:response].reply(text)
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
