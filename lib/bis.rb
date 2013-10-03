require 'bis/conversion'
require 'bis/version'

class Bis
  include Comparable
  include Enumerable

  def self.from_enum(enum)
    from_string(enum.join)
  end

  def self.from_string(string)
    Bis.new(string.size, value: string.to_i(2))
  end

  attr_reader :size
  alias_method :length, :size

  # Future versions of Ruby may have Fixnum#bitlength
  alias_method :bitlength, :size

  def initialize(size, value: 0)
    fail ArgumentError, 'size must be >= 0' if size < 0

    @size = size.to_i
    @store = (value & ((1 << size) - 1)).to_i
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
  # def []=(index, value)
  #   with_valid_bit value do |bit|
  #     case bit
  #     when 1 then set index
  #     when 0 then clear index
  #     end
  #   end
  # end

  def concat(other)
    size_and_value_for(other) do |other_size, other_value|
      new.(size: size + other_size).(value: (to_i << other_size) | other_value)
    end
  end

  def +(other)
    size_and_value_for(other + to_i) do |result_size, result|
      new.(size: result_size).(value: result)
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

  def each_byte
    return enum_for :each_byte unless block_given?

    full_bitset = if size % 8 != 0
                    concat((1 << (8 - (size % 8))) - 1)
                  else
                    self
                  end


    (full_bitset.size / 8).times.reverse_each do |offset|
      yield Bis.new(8, value: (full_bitset >> offset * 8) & ((1 << 8) - 1))
    end
  end

  def bytes
    each_byte.to_a
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

  def <=>(other)
    to_i <=> Bis(other).to_i
  end

  def coerce(other)
    case other
    when Integer
      size_and_value_for(other) do |other_size, other_value|
        [new.(size: other_size).(value: other_value), self]
      end
    else
      fail TypeError, "#{ self.class } cannot be coerced into #{ other.class }"
    end
  end

  def inspect
    "<<#{ to_s }>> #{ to_i }"
  end

  protected

  attr_writer :store

  private

  def size_and_value_for(bitset_or_integer)
    yield bitlenght_for(bitset_or_integer), bitset_or_integer.to_i
  end

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

  def bitlenght_for(bitset_or_integer)
    case bitset_or_integer
    when Bis     then  bitset_or_integer.size
    when 0..1    then 1
    when 2       then 2
    when Integer then  Math.log2(bitset_or_integer).ceil
    else fail ArgumentError, 'cannot resolve a bitlength' +
      "#{ bitset_or_integer }. Must be either Integer" +
      'or Bis'
    end
  end
end
