class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    hash = 0
    self.each_with_index do |el,index|
      hash += el.hash * index
    end
    hash
  end
end

class String
  def hash
    self.chars.map(&:ord).hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    hashed_array = self.to_a.flatten
    hashed_array.map! do |el|
      el.to_s.hash
    end
    hashed_array.sort.hash
  end
end
