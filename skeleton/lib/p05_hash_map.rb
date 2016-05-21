require_relative 'p02_hashing'
require_relative 'p04_linked_list'
require 'byebug'

class HashMap
  include Enumerable
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    @count += 1
    delete(key) if include?(key)
    bucket(key).insert(key, val)
    resize! if count > num_buckets
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    @count -= 1
    bucket(key).remove(key)
  end

  def each
    @store.each do |list|
      list.each do |link|

        yield(link.key, link.val)
      end
    end
  end

  #uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    temp_store = LinkedList.new
    @store.each do |bucket|
      bucket.each do |link|
        temp_store.insert(link.key, link.val)
      end
    end
    @store = Array.new(num_buckets * 2) { LinkedList.new }
    @count = 0

    temp_store.each do |link|
      self.set(link.key, link.val)
    end
  end

  def bucket(key)
    key_hash = key.hash
    @store[key_hash % num_buckets]
    # optional but useful; return the bucket corresponding to `key`
  end
end
