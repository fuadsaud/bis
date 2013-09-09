require 'spec_helper'

describe Bis::Conversion do
  describe '#Bis' do
    subject { Bis(obj) }

    context 'given a Bis object' do
      let(:obj) { Bis.new(10, value: 7) }

      it 'returns the given object' do
        expect(subject).to eq obj
      end
    end

    context 'given an Enumerable' do
      let(:obj) { [0, 1, 1, 0, 1, 1, 0] }

      it 'treats the enumerable as a list of bits' do
        expect(subject).to eq 0b0110110
      end
    end

    context 'given an object that quacks like an Integer' do
      let(:obj) { 26 }

      it 'returns a Bis with the internal value set to the given number' do
        expect(subject).to eq 0b11010
      end
    end
  end
end
