require 'bis/conversion'
require 'bis/version'

class Bis
  WORD_SIZE = 0.size * 8

  attr_reader :size

  def self.from_enum(enum)
    Bis.new(enum.size, value: enum.join.to_i(2))
  end

  def initialize(size, value: 0)
    unless size >= 0
      fail ArgumentError, 'size must be a positive integer'
    end

    @size = size
    @store = Array.new(words_needed_for(size), 0)

    self.value = value if value != 0
  end

  def set(index)
    change_bit_at(index).(1)
  end

  def clear(index)
    change_bit_at(index).(0)
  end

  def [](index)
    x, y = offset_for(index)

    @store[x][y]
  end

  # Not sure if it's a good idead to implement this.
  def []=(index, value)
    with_valid_bit value do |bit|
      case bit
      when 1 then set index
      when 0 then clear index
      end
    end
  end

  def ==(other)
    to_i == other
  end

  def <=>(other)
    to_i <=> Bis(other).to_i
  end

  def +(value)
    with_valid_bit value do |bit|
      new_bis = new.(size: size + 1)

      case bit
      when 1 then new_bis.(value: to_i << 1 | bit)
      when 0 then new_bis.(value: to_i << 1)
      end
    end
  end

  def &(other)
    new_with_same_size.(value: other & to_i)
  end

  def |(other)
    new_with_same_size.(value: other | to_i)
  end

  def ^(other)
    new_with_same_size.(value: other ^ to_i)
  end

  def <<(amount)
    new_with_same_size.(value: to_i << amount)
  end

  def >>(amount)
    new_with_same_size.(value: to_i >> amount)
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

  def to_s
    to_a.join
  end

  def inspect
    "<<#{ to_s }>> #{ to_i }"
  end

  protected
  attr_writer :store

  private

  def value=(value)
    @store.each_with_index do |_, i|
      @store[i] |= Integer(value >> (i * WORD_SIZE))
    end
  end

  def offset_for(index)
    if index >= size
      fail ArgumentError, "index #{index} out of boudaries for #{self}"
    end

    [index / WORD_SIZE, index % WORD_SIZE]
  end


  def words_needed_for(bits)
    (bits - 1) / WORD_SIZE + 1
  end

  def with_valid_bit(bit)
    case bit
    when 0..1 then yield bit
    else fail ArgumentError, 'bit must be either 0 or 1'
    end
  end

  def change_bit_at(index)
    ->(bit) {
      return self if self[index] == bit

      x, y = offset_for(index)

      new_with_same_size.().tap { |bis|
        bis.store = @store.dup.tap { |s|
          s[x] = s[x].send(change_operation_for(bit), 1 << y)
        }
      }
    }
  end

  def change_operation_for(bit)
    bit.zero? ? :^ : :|
  end

  def new_with_same_size
    new.(size: size)
  end

  def new(factory = self.class)
    ->(size: size) {
      ->(value: 0) {
        factory.new(size, value: value)
      }
    }
  end
end
