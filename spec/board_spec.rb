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
        actual = new_board.whites.count { |piece| piece.color == :w }
        expect(actual).to eq 16
      end

      it 'generates a list of black pieces' do
        actual = new_board.blacks.count { |piece| piece.color == :b }
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

  describe '#check?' do
    context 'starting position' do
      subject(:starting_board) { described_class.new }
      it 'returns false for white' do
        expect(starting_board.check?(:w)).to be false
      end

      it 'returns false for black' do
        expect(starting_board.check?(:b)).to be false
      end
    end

    context 'black in check' do
      subject(:black_in_check) { described_class.new('3k4/8/8/8/8/8/8/2KR4 w - - 0 1') }
      it 'returns true for white' do
        expect(black_in_check.check?(:w)).to be true
      end

      it 'returns false for black' do
        expect(black_in_check.check?(:b)).to be false
      end
    end

    context 'white in check' do
      subject(:white_in_check) { described_class.new('2rk4/8/8/8/8/8/8/2K4 w - - 0 1') }
      it 'returns false for white' do
        expect(white_in_check.check?(:w)).to be false
      end

      it 'returns true for black' do
        expect(white_in_check.check?(:b)).to be true
      end
    end
  end

  describe '#take_turn' do
    context 'starting position' do
      subject(:starting_board) { described_class.new }
      before do
        allow(starting_board).to receive(:puts)
      end
      it 'moves a pawn one square' do
        starting_board.take_turn([6, 3], [5, 3])
        expect(starting_board.board[43].type).to eq(:p)
      end

      it 'sets the starting square to nil' do
        starting_board.take_turn([6, 3], [5, 3])
        expect(starting_board.board[51]).to be nil
      end

      it 'moves a knight correctly' do
        starting_board.take_turn([7, 1], [5, 0])
        expect(starting_board.board[40].type).to eq(:n)
      end

      it 'outputs an error message when a king move is attempted' do
        expect(starting_board).to receive(:puts).with('Invalid move, the selected piece does not move like that.')
        starting_board.take_turn([7, 4], [6, 4])
      end

      it 'outputs an error message if a move with opponents piece is attempted' do
        expect(starting_board).to receive(:puts).with('Invalid move, starting square needs to contain one of your pieces.')
        starting_board.take_turn([1, 4], [2, 4])
      end
    end
  end
end
