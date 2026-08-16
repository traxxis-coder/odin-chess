require_relative '../lib/piece'

describe Piece do
  describe '#initialize' do
    context 'single pieces' do
      context 'white knight' do
        subject(:white_knight) { described_class.new('N', 62) }

        it 'creates a piece of the correct color' do
          expect(white_knight.color).to eq :white
        end

        it 'creates a piece of the correct type' do
          expect(white_knight.type).to eq :n
        end

        it 'creates the piece in the correct square' do
          expect(white_knight.square).to eq [7, 6]
        end

        it 'correctly sets its move set' do
          expected = { list: [[1, 2], [-1, -2], [-1, 2], [1, -2], [2, 1], [-2, -1], [-2, 1], [2, -1]],
                       type: :single }
          actual = white_knight.moves
          expect(actual).to eq expected
        end
      end

      context 'black rook' do
        subject(:black_rook) { described_class.new('r', 0) }

        it 'correctly recognises a black piece' do
          expect(black_rook.color).to eq :black
        end

        it 'correctly sets it move set' do
          expected = { list: [[0, 1], [0, -1], [1, 0], [-1, 0]],
                       type: :iter }
          actual = black_rook.moves
          expect(actual).to eq expected
        end
      end

      context 'white pawn double' do
        subject(:white_pawn_double) { described_class.new('P', 53) }

        it 'correctly sets up its move set' do
          expected = { list: [[-1, 0], [-2, 0]],
                       type: :single }
          actual = white_pawn_double.moves
          expect(actual).to eq expected
        end

        it 'correctly sets up its threat set' do
          expected = { list: [[-1, -1], [-1, 1]],
                       type: :single }
          actual = white_pawn_double.threats
          expect(actual).to eq expected
        end
      end

      context 'white pawn single' do
        subject(:white_pawn_single) { described_class.new('P', 10) }

        it 'correctly sets up its move set' do
          expected = { list: [[-1, 0]],
                       type: :single }
          actual = white_pawn_single.moves
          expect(actual).to eq expected
        end
      end

      context 'black pawn double' do
        subject(:black_pawn_double) { described_class.new('p', 10) }

        it 'correctly sets up its move set' do
          expected = { list: [[1, 0], [2, 0]],
                       type: :single }
          actual = black_pawn_double.moves
          expect(actual).to eq expected
        end

        it 'correctly sets up its threat set' do
          expected = { list: [[1, -1], [1, 1]],
                       type: :single }
          actual = black_pawn_double.threats
          expect(actual).to eq expected
        end
      end

      context 'black pawn single' do
        subject(:black_pawn_single) { described_class.new('p', 53) }

        it 'correctly sets up its move set' do
          expected = { list: [[1, 0]],
                       type: :single }
          actual = black_pawn_single.moves
          expect(actual).to eq expected
        end
      end
    end
  end
end
