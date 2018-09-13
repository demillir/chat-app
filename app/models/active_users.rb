# This singleton class represents the set of all the +User+ objects for signed-in users.
# It stores the set of +User+ objects in Redis, so all running instances of this application
# see the same set.

class ActiveUsers
  include Singleton
  include Enumerable

  def initialize
    @redis_key = "#{self.class.name}:#{Rails.env}"
  end

  def <<(obj)
    $redis.sadd @redis_key, Marshal.dump(obj)
  end

  def delete(obj)
    $redis.srem @redis_key, Marshal.dump(obj)
  end

  def each
    $redis.smembers(@redis_key)
      .map {|dump| Marshal.load(dump)}
      .each {|user| yield user}
  end

  def clear
    $redis.del @redis_key
  end
end
