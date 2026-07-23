require_relative 'piece'

class Board
  attr_reader :board, :active_player

  def initialize(string)
    @board = []
    populate_board(string)
    @active_player = string.split(' ')[1].to_sym
    @castling = string.split(' ')[2]
    @en_passant = string.split(' ')[3]
    @half_moves = string.split(' ')[4]
    @turn = string.split(' ')[5]
  end

  # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
  def populate_board(string)
    string = string.split(' ')[0].split('/').reverse.join('')
    index = 0
    string.each_char do |char|
      if char.match?(/[[:alpha:]]/)
        @board << Piece.new(char, index)
        index += 1
      else
        n = char.to_i
        n.times { @board << nil }
        index += n
      end
    end
  end
end
