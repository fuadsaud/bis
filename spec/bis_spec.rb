require 'spec_helper'

describe Bis do
  let(:size) { Bis::WORD_SIZE }

  it('has a version') { expect(Bis::VERSION).to be_a String }

  describe '.new' do
    context 'with size' do
      let(:size) { 8 }

      subject { Bis.new(size) }

      it 'is as big as the passed size' do
        expect(subject.size).to eq size
      end

      it 'has all bits off' do
        expect(subject).to eq 0
      end
    end

    context 'with size and value' do
      let(:value) { 10 }
      subject { Bis.new(size, value: value) }

      it 'is as big as the passed size' do
        expect(subject.size).to eq size
      end

      it 'has the bits set to the given value' do
        expect(subject).to eq value
      end
    end
  end

  describe '#==' do
    context 'with an integer' do
      let(:value) { 16 }
      subject { Bis.new(size, value: value) }

      it 'compares to the bitset' do
        expect(subject).to eq value
      end

      it 'compares properly' do
        expect(subject).to_not eq value - 1
      end
    end
  end

  describe '#[]' do
    context 'small numbers' do
      subject { Bis.new(size, value: 10) }

      it 'returns the bit at the given position' do
        expect(subject[3]).to eq 1
      end
    end

    context 'large numbers' do
      let(:size) { 65 }
      subject { Bis.new(size).set(64) }

      it 'returns the bit at the given position' do
        expect(subject[64]).to eq 1
      end
    end
  end

  describe '#set' do
    let(:before) { 0b101 }
    let(:after) { 0b111 }
    subject { Bis.new(size, value: before) }

    it 'returns a new bitset with the given bit on' do
      expect(subject.set(1)).to eq after
    end
  end

  describe '#clear' do
    let(:before) { 0b111 }
    let(:after) { 0b101 }
    subject { Bis.new(size, value: before) }

    it 'returns a new bitset with the given bit off' do
      expect(subject.clear(1)).to eq after
    end
  end

  describe '#to_i' do
    let(:size) { 4 }
    subject { Bis.new(size, value: 0b100) }

    it "returns it's integer representation" do
      expect(subject).to eq 4
    end
  end

  describe '#&' do
    it 'evaluates to logic AND of the two bitsets' do
      expect(Bis.new(size, value: 0b1100) &
             Bis.new(size, value: 0b0101)).to eq Bis.new(size, value: 0b0100)
    end
  end

  describe '#|' do
    it 'evaluates to logic OR of the two bitsets' do
      expect(Bis.new(size, value: 0b1100) |
             Bis.new(size, value: 0b0110)).to eq Bis.new(size, value: 0b1110)
    end
  end

  describe '#^' do
    it 'evaluates to logic XOR of the two bitsets' do
      expect(Bis.new(size, value: 0b1100) ^
             Bis.new(size, value: 0b0110)).to eq Bis.new(size, value: 0b1010)
    end
  end

  describe '#>>' do
    let(:shift) { 1 }

    context 'zero value' do
      subject { Bis.new(size) }

      it 'remains zero' do
        expect(subject >> shift).to eq 0
      end
    end

    context 'non-zero value' do
      let(:value) { 10 }
      subject { Bis.new(size, value: value) }

      it 'shifts the internal value properly' do
        expect(subject >> shift).to eq value >> shift
      end
    end
  end

  describe '#<<' do
    let(:shift) { 1 }

    context 'zero value' do
      subject { Bis.new(size) }

      it 'remains zero' do
        expect(subject << shift).to eq 0
      end
    end

    context 'non-zero value' do
      let(:value) { 10 }
      subject { Bis.new(size, value: value) }

      it 'shifts the internal value properly' do
        expect(subject << shift).to eq value << shift
      end
    end
  end
end
