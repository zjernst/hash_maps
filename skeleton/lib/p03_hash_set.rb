require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    unless include?(key)
      key_hash = key.hash
      @count += 1
      self[key_hash] << key
    end
    if @count > num_buckets
      resize!
    end
  end

  def include?(key)
    key_hash = key.hash
    self[key_hash].include?(key)
  end

  def remove(key)
    key_hash = key.hash
    if include?(key)
      @count -= 1
      self[key_hash].delete(key)
    end
  end

  private

  def [](hash)
    @store[hash%num_buckets]
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end

  def resize!
    temp_store = []
    @store.each do |bucket|
      bucket.each do |key|
        temp_store << key
      end
    end
    @store = Array.new(num_buckets * 2) { Array.new }
    @count = 0

    temp_store.each do |key|
      self.insert(key)
    end
  end
end
