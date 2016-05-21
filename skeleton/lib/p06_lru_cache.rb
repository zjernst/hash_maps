require_relative 'p05_hash_map'
require_relative 'p04_linked_list'
require 'byebug'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    #byebug
    if @map.include?(key)
      update_link!(@map[key])
      @map[key].val
    else
      calc!(key)
      eject! if count > @max

      @map[key].val
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    val = @prc.call(key)
    link = @store.insert(key, val)

    @map.set(key, link)
    # suggested helper method; insert an (un-cached) key
  end

  def update_link!(link)
    @store.remove(link.key)
    @store.insert(link.key,link.val)# suggested helper method; move a link to the end of the list
  end

  def eject!
    deleted = @store.shift
    @map.delete(deleted.key)
  end
end
