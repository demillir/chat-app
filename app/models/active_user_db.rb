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
      with_hash do |hash|
        hash.delete(key)
      end
    }
  end

  def [](key)
    dump = fetch_hash[key]
    dump && decode(dump)
  end

  def []=(key, value)
    with_hash do |hash|
      hash[key] = encode(value)
    end
    return value
  end

  def each
    fetch_hash
      .transform_values {|dump| decode(dump)}
      .each {|pair| yield pair}
  end

  def clear
    $redis.del @redis_key
  end

  private

  def with_hash
    hash = fetch_hash
    yield hash
    $redis.set @redis_key, hash.to_json
  end

  def fetch_hash
    json = $redis.get @redis_key
    return {} unless json.present?

    JSON.parse(json)
  end

  def encode(obj)
    Base64.encode64(Marshal.dump(obj))
  end

  def decode(base64)
    Marshal.load(Base64.decode64(base64))
  end
end
