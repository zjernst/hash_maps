
class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Link.new
    @tail = Link.new

    @head.prev = @tail
    @head.next = @tail

    @tail.prev = @head
    @tail.next = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    @head.next == @tail && @tail.prev == @head
  end

  def get(key)
    self.each do |link|
      return link.val if link.key == key
    end
    nil
  end

  def include?(key)
    self.each do |link|
      return true if link.key == key
    end
    false
  end

  def insert(key, val)
    new_link = Link.new(key, val)
    new_link.next = @tail
    last.next = new_link
    new_link.prev = last
    @tail.prev = new_link
    new_link
  end

  def remove(key)
    deleted_link = nil
    self.each do |link|
      if link.key == key
        deleted_link = link
      end
    end
    old_prev = deleted_link.prev
    old_next = deleted_link.next
    old_prev.next = old_next
    old_next.prev = old_prev
    deleted_link
  end

  def shift
    shifted = first
    @head.next = first.next
    first.next.prev = @head
    shifted
  end

  def unshift(key,val)
    new_link = Link.new(key, val)
    new_link.prev = @head
    first.prev = new_link
    new_link.next = first
    @head.next = new_link
    new_link
  end

  def each
    start = @head.next
    current = start
    until current == @tail
      yield(current)
      current = current.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
