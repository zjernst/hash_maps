require 'byebug'

class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  attr_reader :count
  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    return nil if @count == 0 || i >= @count
    i += @count if i < 0
    return nil if i < 0
    @store[i]
  end

  def []=(i, val)
    i += @count if i < 0
    i = 0 if @count == 0
    @store[i] = val
  end

  def capacity
    @store.length
  end

  def include?(val)
    self.each do |el|
      return true if val == el
    end
    false
  end

  def push(val)
    resize! if @count == capacity

    i = @count
    @count += 1
    self[i] = val
  end

  def unshift(val)
    resize! if @count == capacity

    i = @count
    while i > 0
      self[i] = self[i-1]
      i -= 1
    end
    @count += 1
    self[i] = val
  end

  def pop
    return nil if @count.zero?
    element = self[@count - 1]
    self[@count - 1] = nil
    @count -= 1
    element
  end

  def shift
    element = self[0]
    index = 0
    until self[index] == nil
      self[index] = self[index + 1]
      index += 1
    end
    @count -= 1
    element
  end

  def first
    self[0]
  end

  def last
    return nil if @count.zero?
    self[@count - 1]
  end

  def each
    i = 0
    while i < capacity
      yield(@store[i])
      i += 1
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    self.each_with_index do |el, index|
      return false unless el == other[index]
    end
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    temp = @store
    @store = StaticArray.new(capacity * 2)
    index = 0
    @count = 0
    while index < temp.length
      push(temp[index])
      index += 1
    end
  end
end
