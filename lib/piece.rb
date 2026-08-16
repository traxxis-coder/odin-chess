require 'pry-byebug'

class Piece
  SYMBOLS = {
    white: {
      r: "\e[38;2;255;255;255m\u{2656}",
      n: "\e[38;2;255;255;255m\u{2658}",
      b: "\e[38;2;255;255;255m\u{2657}",
      k: "\e[38;2;255;255;255m\u{2654}",
      q: "\e[38;2;255;255;255m\u{2655}",
      p: "\e[38;2;255;255;255m\u{2659}"
    },
    black: {
      r: "\e[38;2;0;0;0m\u{265C}",
      n: "\e[38;2;0;0;0m\u{265E}",
      b: "\e[38;2;0;0;0m\u{265D}",
      k: "\e[38;2;0;0;0m\u{265A}",
      q: "\e[38;2;0;0;0m\u{265B}",
      p: "\e[38;2;0;0;0m\u{265F}"
    }
  }.freeze
  attr_reader :color, :type, :moves, :threats, :square

  def initialize(piece, index)
    @color = piece == piece.upcase ? :white : :black
    @type = piece.downcase.to_sym
    @square = unhash(index)
    @moves = move_set
    @threats = threat_set
  end

  private

  def unhash(index)
    [index / 8, index % 8]
  end

  def move_set
    case @type
    when :r
      rook_moves
    when :n
      knight_moves
    when :b
      bishop_moves
    when :k
      king_moves
    when :q
      queen_moves
    when :p
      pawn_moves
    end
  end

  def rook_moves
    { list: [[0, 1], [0, -1], [1, 0], [-1, 0]],
      type: :iter }
  end

  def knight_moves
    { list: [[1, 2], [-1, -2], [-1, 2], [1, -2], [2, 1], [-2, -1], [-2, 1], [2, -1]],
      type: :single }
  end

  def bishop_moves
    { list: [[1, 1], [1, -1], [-1, 1], [-1, -1]],
      type: :iter }
  end

  def king_moves
    moves = { list: [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]],
              type: :single }
    moves.list += [[0, 2], [0, -2]] if color == :black && square == [0, 4] || color == :white && square == [7, 4]
    moves
  end

  def queen_moves
    { list: bishop_moves[:list] + rook_moves[:list],
      type: :iter }
  end

  def pawn_moves
    if color == :white
      if square[0] == 6
        { list: [[-1, 0], [-2, 0]],
          type: :single }
      else
        { list: [[-1, 0]],
          type: :single }
      end
    elsif square[0] == 1
      { list: [[1, 0], [2, 0]],
        type: :single }
    else
      { list: [[1, 0]],
        type: :single }
    end
  end

  def threat_set
    if @type == :p
      pawn_threats
    else
      @moves
    end
  end

  def pawn_threats
    if color == :white
      { list: [[-1, -1], [-1, 1]],
        type: :single }
    else
      { list: [[1, -1], [1, 1]],
        type: :single }
    end
  end
end
