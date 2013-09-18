require 'bis/conversion'
require 'bis/version'

class Bis
  attr_reader :size

  def self.from_enum(enum)
    Bis.new(enum.size, value: enum.join.to_i(2))
  end

  def initialize(size, value: 0)
    unless size >= 0
      fail ArgumentError, 'size must be a positive integer'
    end

    @size = size
    @store = value
  end

  def set(index)
    new_with_same_size.(value: @store | 1 << index)
  end

  def clear(index)
    new_with_same_size.(value: @store & (~(1 << index)))
  end

  def [](index)
    with_valid_index index do |index|
      @store[index]
    end
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
    other == to_i
  end

  def <=>(other)
    to_i <=> Bis(other).to_i
  end

  def +(value)
    with_valid_bit value do |bit|
      new.(size: size + 1).(value: to_i << 1 | bit)
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
    @store
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

  def with_valid_bit(bit)
    case bit
    when 0..1 then yield bit
    else fail ArgumentError, 'bit must be either 0 or 1'
    end
  end

  def with_valid_index(index)
    case index
    when 0..@size then yield index
    else fail ArgumentError, "index #{index} out of boudaries for #{self}"
    end
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
