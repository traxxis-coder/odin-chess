require_relative '../lib/piece'

describe Piece do
  describe '#initialize' do
    subject(:new_piece) { described_class.new('n', 2) }
    subject(:black_piece) { described_class.new('R', 64) }

    it 'creates a piece of the correct color' do
      expect(new_piece.color).to eq :white
    end

    it 'creates a piece of the correct type' do
      expect(new_piece.type).to eq :n
    end

    it 'creates the piece in the correct square' do
      expect(new_piece.square).to eq 'b1'
    end

    it 'correctly recognises a black piece' do
      expect(black_piece.color).to eq :black
    end
  end
end
