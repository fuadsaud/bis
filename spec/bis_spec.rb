require 'spec_helper'

describe Bis do
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
      subject { Bis.new(size, value: value) }

      context 'with a bitset big enough to fit given size' do
        let(:size) { 16 }
        let(:value) { 10 }

        it 'is as big as the passed size' do
          expect(subject.size).to eq size
        end

        it 'has the bits set to the given value' do
          expect(subject).to eq value
        end
      end

      context 'with value overflowing the size' do
        let(:size) { 3 }
        let(:value) { 10 }
        subject { Bis.new(size, value: value) }

        it 'is as big as the passed size' do
          expect(subject.size).to eq size
        end

        it 'truncates the given value to fit in the given biy length' do
          expect(subject.to_i).to eq 2
        end
      end
    end
  end

  describe '#==' do
    context 'with an integer' do
      let(:size) { 16 }
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
    context 'invalid index' do
      let (:size) { 10 }

      subject { Bis.new(size) }

      it 'fails' do
        expect { subject[11] }.to raise_error
      end
    end

    context 'small numbers' do
      let(:size) { 16 }
      let(:value) { 10 }

      subject { Bis.new(size, value: value) }

      it 'returns the bit at the given position' do
        expect(subject[3]).to eq 1
      end
    end

    context 'large numbers' do
      let(:size) { 65 }

      subject { Bis.new(size).set(16) }

      it 'returns the bit at the given position' do
        expect(subject[16]).to eq 1
      end
    end
  end

  describe '#[]=', pending: "Not sure if it's a good idea to implement this" do
    context 'invalid argument' do
      let(:size) { 16 }
      subject { Bis.new(size) }

      it 'fails' do
        expect { subject[4] = 'lol' }.to raise_error
      end
    end

    context 'valid argument' do
      let(:size) { 16 }
      let(:value) { 7 }

      subject { Bis.new(size, value: 7)[index] = argument }

      context '1' do
        let(:index) { 4 }
        let(:argument) { 1 }

        it 'sets the given bit' do
          expect(subject).to eq(value | (argument << index))
        end
      end

      context '0' do
        let(:index) { 1 }
        let(:argument) { 0 }

        it 'clears the given bit' do
          expect(subject).to eq(value ^ (1 << index))
        end
      end
    end
  end

  describe '#set' do
    let(:size) { 16 }
    let(:before) { 0b101 }
    let(:after) { 0b111 }

    subject { Bis.new(size, value: before) }

    it 'returns a new bitset with the given bit on' do
      expect(subject.set(1)).to eq after
    end
  end

  describe '#clear' do
    let(:size) { 16 }
    let(:before) { 0b111 }
    let(:after) { 0b101 }

    subject { Bis.new(size, value: before) }

    it 'returns a new bitset with the given bit off' do
      expect(subject.clear(1)).to eq after
    end
  end

  describe '#to_a' do
    let(:size) { 8 }

    subject { Bis.new(size, value: 0b01010110).to_a }

    it 'returns a binary array representation of itself' do
      expect(subject).to eq [0, 1, 0, 1, 0, 1, 1, 0]
    end
  end

  describe '#to_i' do
    let(:size) { 4 }

    subject { Bis.new(size, value: 0b100) }

    it "returns it's integer representation" do
      expect(subject).to eq 4
    end
  end

  describe '#to_s' do
    let(:size) { 8 }

    subject { Bis.new(size, value: 0b01010110).to_s }

    it 'returns a binary array representation of itself' do
      expect(subject).to eq '01010110'
    end
  end

  shared_examples 'pushing a bit' do
  end

  describe '#concat' do
    subject { Bis.new(size, value: value).concat(argument) }

    context '0' do
      context 'zero' do
        let(:size) { 8 }
        let(:value) { 10 }
        let(:argument) { 0 }
        let(:argument_size) { 1 }
        let(:new_value) { (value << argument_size) | argument }

        it 'has the orginal size plus enough to fit the new integer value' do
          expect(subject.size).to eq size + argument_size
        end

        it "concatenates the integer bits to the end it's end" do
          expect(subject).to eq new_value
        end
      end

      context '1' do
        let(:size) { 8 }
        let(:value) { 10 }
        let(:argument) { 1 }
        let(:argument_size) { 1 }
        let(:new_value) { (value << argument_size) | argument }

        it 'has the orginal size plus enough to fit the new integer value' do
          expect(subject.size).to eq size + argument_size
        end

        it "concatenates the integer bits to the end it's end" do
          expect(subject).to eq new_value
        end
      end


      context '> 1' do
        let(:size) { 8 }
        let(:value) { 10 }
        let(:argument) { 3 }
        let(:argument_size) { 2 }
        let(:new_value) { (value << argument_size) | argument }

        it 'has the orginal size plus enough to fit the new integer value' do
          expect(subject.size).to eq size + argument_size
        end

        it "concatenates the integer bits to the end it's end" do
          expect(subject).to eq new_value
        end
      end
    end

    context 'with a bitset' do
      let(:size) { 4 }
      let(:value) { 3 }
      let(:argument_size) { 10 }
      let(:argument_value) { 10 }
      let(:argument) { Bis.new(argument_size, value: argument_value) }
      let(:new_value) { (value << argument_size) | argument_value }

      it 'returns a new bitset with the size of both bitsets combined' do
        expect(subject.size).to eq size + argument_size
      end

      it 'concatenates the two bitsets' do
        expect(subject.to_i).to eq new_value
      end
    end
  end

  describe '#+' do
    context 'with an integer' do
    end
  end

  describe '#&' do
    let(:size) { 16 }

    subject { Bis.new(size, value: value) & argument }

    context 'with an integer' do
      let(:size) { 16 }
      let(:value) { 12 }
      let(:argument) { 5 }
      let(:result) { value & argument }

      it 'evaluates to logic AND of the two bitsets' do
        expect(subject).to eq result
      end
    end

    context 'with another bitset' do
      let(:size) { 16 }
      let(:value) { 12 }
      let(:argument_value) { 5 }
      let(:argument) { Bis.new(size, value: argument_value) }
      let(:result) { value & argument_value }

      it 'evaluates to logic AND of the two bitsets' do
        expect(subject).to eq result
      end
    end
  end

  describe '#|' do
    let(:size) { 16 }

    subject { Bis.new(size, value: value) | argument }

    context 'with an integer' do
      let(:size) { 16 }
      let(:value) { 12 }
      let(:argument) { 5 }
      let(:result) { value | argument }

      it 'evaluates to logic AND of the two bitsets' do
        expect(subject).to eq result
      end
    end

    context 'with another bitset' do
      let(:size) { 16 }
      let(:value) { 12 }
      let(:argument_value) { 5 }
      let(:argument) { Bis.new(size, value: argument_value) }
      let(:result) { value | argument_value }

      it 'evaluates to logic OR of the two bitsets' do
        expect(subject).to eq result
      end
    end
  end

  describe '#^' do
    let(:size) { 16 }

    subject { Bis.new(size, value: value) ^ argument }

    context 'with an integer' do
      let(:size) { 16 }
      let(:value) { 12 }
      let(:argument) { 5 }
      let(:result) { value ^ argument }

      it 'evaluates to logic AND of the two bitsets' do
        expect(subject).to eq result
      end
    end

    context 'with another bitset' do
      let(:size) { 16 }
      let(:value) { 12 }
      let(:argument_value) { 5 }
      let(:argument) { Bis.new(size, value: argument_value) }
      let(:result) { value ^ argument_value }

      it 'evaluates to logic XOR of the two bitsets' do
        expect(subject).to eq result
      end
    end
  end

  describe '#>>' do
    let(:size) { 16 }
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
    let(:size) { 16 }
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
