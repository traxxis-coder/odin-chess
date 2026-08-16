require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    context 'starting board setting' do
      subject(:new_board) { described_class.new }
      it 'generates a @board array of length 64' do
        expect(new_board.board.size).to eq 64
      end

      it 'generates a @board with 32 pieces' do
        actual = new_board.board.count { |square| square.instance_of?(Piece) }
        expect(actual).to eq 32
      end

      it 'generates a list of white pieces' do
        actual = new_board.whites.count { |piece| piece.color == :white }
        expect(actual).to eq 16
      end

      it 'generates a list of black pieces' do
        actual = new_board.blacks.count { |piece| piece.color == :black }
        expect(actual).to eq 16
      end

      it 'generates a @board with 32 empty squares' do
        actual = new_board.board.count(&:nil?)
        expect(actual).to eq 32
      end

      it 'sets @active_player to white' do
        expect(new_board.active_player).to eq :w
      end
    end

    context 'empty board' do
      subject(:empty_board) { described_class.new('8/8/8/8/8/8/8/8 w KQkq - 0 1') }
      before do
        allow(empty_board).to receive(:display_board)
      end

      it 'makes a board with 64 squares' do
        expect(empty_board.board.size).to eq 64
      end

      it 'makes all squares empty' do
        actual = empty_board.board.all?(&:nil?)
        expect(actual).to be true
      end
    end
  end
end
