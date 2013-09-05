require 'spec_helper'

describe Bis do
  it('has a version') { expect(Bis::VERSION).to be_a String }

  describe '.new' do
    context 'with no params' do
      it 'has a single 0 bit' do
        expect(Bis.new).to eq [0]
      end
    end

    context 'with length' do
      let(:length) { 8 }

      it 'is as big as the passed length' do
        expect(Bis.new(length).size).to eq length
      end

      it 'has all bits off' do
        expect(Bis.new(length)).to eq [0] * length
      end
    end
  end

  describe '.from_enum' do
    context 'empty enum' do
      it 'has a single 0 bit' do
        expect(Bis.from_enum([])).to eq [0]
      end
    end

    context 'non empty enum' do
      it 'has a single 0 bit' do
        expect(Bis.from_enum([])).to eq [0]
      end
    end
  end

  describe '#set' do
    it 'returns a new bitset with the given bit on' do
      expect(Bis.from_enum([1, 0, 1]).set(1)).to eq [1, 1, 1]
    end
  end

  describe '#clear' do
    it 'returns a new bitset with the given bit on' do
      expect(Bis.from_enum([1, 0, 1]).set(1)).to eq [1, 1, 1]
    end
  end

  describe '#to_i' do
    it 'treats the bitset as a base 2 number' do
      expect(Bis.from_enum([1, 0, 0])).to eq 4
    end
  end

  describe '#&' do
    it 'evaluates to logic and of the two bitsets' do
      expect(Bis.from_enum([1, 1, 0, 0]) &
             Bis.from_enum([0, 1, 1, 0])).to eq Bis.from_enum([0, 1, 0, 0])
    end
  end

  describe '#|' do
    it 'evaluates to logic and of the two bitsets' do
      expect(Bis.from_enum([1, 1, 0, 0]) |
             Bis.from_enum([0, 1, 1, 0])).to eq Bis.from_enum([0, 1, 0, 0])
    end
  end

  describe '#^' do
    it 'evaluates to logic and of the two bitsets' do expect(Bis.from_enum([1, 1, 0, 0]) ^
             Bis.from_enum([0, 1, 1, 0])).to eq Bis.from_enum([0, 1, 0, 0])
    end
  end
end
