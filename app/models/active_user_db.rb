# This singleton class represents the set of all the +User+ objects for signed-in users.
# It stores the set of +User+ objects in Redis, so all running instances of this application
# see the same set.
#
# Client code accesses the set with a +Hash+-like interface; the set elements are keyed by the +User+ name.

class ActiveUserDB
  include Singleton
  include Enumerable

  def initialize
    @redis_key = "#{self.class.name}:#{Rails.env}:hash"
  end

  def delete(key)
    self[key].tap {
      $redis.hdel @redis_key, key
    }
  end

  def [](key)
    dump = $redis.hget @redis_key, key
    dump && Marshal.load(dump)
  end

  def []=(key, value)
    $redis.hset @redis_key, key, Marshal.dump(value)
    return value
  end

  def each
    $redis.hgetall(@redis_key)
      .transform_values {|dump| Marshal.load(dump)}
      .each {|pair| yield pair}
  end

  def clear
    $redis.del @redis_key
  end
end
