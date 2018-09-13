# This singleton class represents the set of all the +User+ objects for signed-in users.
# It stores the set of +User+ objects in Redis, so all running instances of this application
# see the same set.
#
# Client code accesses the set with a +Hash+-like interface; the set elements are keyed by the +User+ name.

class ActiveUserDB
  include Singleton
  include Enumerable

  def initialize
    @redis_key = "#{self.class.name}:#{Rails.env}"
  end

  def delete(key)
    obj = self[key]
    $redis.srem(@redis_key, Marshal.dump(obj)) ? obj : nil
  end

  def [](key)
    find { |name, user| name == key }&.second
  end

  def []=(key, value)
    $redis.sadd @redis_key, Marshal.dump(value)
  end

  def each
    $redis.smembers(@redis_key)
      .map {|dump| Marshal.load(dump)}
      .each {|user| yield [user.name, user]}
  end

  def clear
    $redis.del @redis_key
  end
end
