require 'forwardable'

require 'bis/conversion'
require 'bis/version'

class Bis
  WORD_SIZE = 0.size * 8

  attr_reader :size

  def self.from_enum(enum)
    Bis.new(enum.size, value: enum.join.to_i(2))
  end

  def initialize(size, value: 0)
    unless size.kind_of?(Integer) && size > 0
      fail ArgumentError, 'size must be a positive integer'
    end

    @size = size
    @store = Array.new(words_needed_for(size), 0)

    self.value = value if value != 0
  end

  def [](index)
    x, y = offset_for(index)

    @store[x][y]
  end

  def []=(index, value)
    if value == 1
      set(index)
    elsif value == 0
      clear(index)
    else
      fail ArgumentError, 'bit must be set to either 0 or 1'
    end
  end

  def set(index)
    return self if self[index] == 1

    x, y = offset_for(index)

    self.class.new(size).tap { |bis|
      bis.store = @store.dup.tap { |s|
        s[x] |= 1 << y
      }
    }
  end

  def clear(index)
    return self if self[index] == 0

    x, y = offset_for(index)

    self.class.new(size).tap { |bis|
      bis.store = @store.dup.tap { |s|
        s[x] ^= 1 << y
      }
    }
  end

  def &(other)
    new_with_same_size_factory.((other & to_i))
  end

  def |(other)
    new_with_same_size_factory.((other | to_i))
  end

  def ^(other)
    new_with_same_size_factory.((other ^ to_i))
  end

  def <<(amount)
    new_with_same_size_factory.(to_i << amount)
  end

  def >>(amount)
    new_with_same_size_factory.(to_i >> amount)
  end

  def each
    return enum_for :each unless block_given?

    size.times.reverse_each do |bit|
      yield self[bit]
    end
  end

  def to_a
    each.to_a
  end

  def to_i
    each.reduce(0) { |a, e| (a << 1) | e }
  end

  def inspect

    to_i.to_s
  end

  def ==(other)
    to_i == other
  end

  def <=>(other)
    to_i <=> Bis(other).to_i
  end

  protected

  def store=(store)
    @store = store
  end

  private

  def offset_for(index)
    [index / WORD_SIZE, index % WORD_SIZE]
  end

  def words_needed_for(bits)
    (bits - 1) / WORD_SIZE + 1
  end

  def new_with_same_size_factory
    ->(value) { self.class.new(size, value: value) }
  end

  def value=(value)
    @store.each_with_index do |_, i|
      @store[i] |= Integer(value >> (i * WORD_SIZE))
    end
  end
end
