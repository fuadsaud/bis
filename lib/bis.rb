require 'forwardable'

require 'bis/conversion'
require 'bis/version'

class Bis
  extend Forwardable

  
  def self.from_enum(enum)
    return new if enum.nil? || enum.empty?

    normalize_set(enum).each_with_index
                       .each_with_object(new(enum.size)) do |(bit_on, i), bis|
      bis.set(i) if bit_on
    end
  end

  def_delegators :@bitset, :to_s, :each, :size, :zip

  def initialize(length = 1)
    unless length.kind_of?(Integer)
      fail ArgumentError, 'length must be a positive integer'
    end

    @bitset = [false] * length
  end

  def set(index)
    @bitset = normalize_set(@bitset.tap { |bs| bs[index] = true })
  end

  def &(other)
    zip(other).map { |tuple|
      p tuple
      tuple.first & tuple.last
    }
  end

  def |(other)
    zip(other).map { |tuple|
      tuple.first | tuple.last
    }
  end

  def ^(other)
    zip(other).map { |tuple|
      tuple.first ^ tuple.last
    }
  end

  def <<(amount)
    +([false] * amount)
  end

  def >>(amount)

  end

  def to_i(base)
    join.to_i(2)
  end

  def ==(other)
    @bitset == normalize_set(other)
  end

  def <=>(other)
    to_i <=> Bis(other).to_i
  end

  private

  def self.normalize_set(enum)
    enum.map { |b| !(!b || b == 0) }
  end

  def normalize_set(enum)
    self.class.normalize_set(enum)
  end
end
