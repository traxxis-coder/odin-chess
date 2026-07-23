require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    subject(:new_board) { described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1') }

    it 'generates a @board array of length 64' do
      expect(new_board.board.size).to eq 64
    end

    it 'generates a @board with 32 pieces' do
      actual = new_board.board.count { |square| square.instance_of?(Piece) }
      expect(actual).to eq 32
    end

    it 'generates a @board with 32 empty squares' do
      actual = new_board.board.count(&:nil?)
      expect(actual).to eq 32
    end

    it 'sets @active_player to white' do
      expect(new_board.active_player).to eq :w
    end
  end
end
