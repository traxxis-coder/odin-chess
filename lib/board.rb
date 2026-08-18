require_relative 'piece'
require 'pry-byebug'

class Board
  attr_reader :board, :active_player, :whites, :blacks, :white_king, :black_king

  def initialize(string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    @board = []
    @blacks = []
    @whites = []
    populate_board(string)
    @active_player = string.split(' ')[1].to_sym
    @castling = string.split(' ')[2]
    @en_passant = string.split(' ')[3]
    @half_moves = string.split(' ')[4].to_i
    @turn = string.split(' ')[5].to_i
  end

  def display_board
    print "\e[H\e[2J"
    puts "\n   a  b  c  d  e  f  g  h"

    row = 0
    @board.each_with_index do |square, i|
      print " #{8 - i / 8}" if (i % 8).zero?

      bg = (i + row).even? ? "\e[48;2;180;180;180m" : "\e[48;2;120;120;120m"
      piece = square.nil? ? '   ' : " #{Piece::SYMBOLS[square.color][square.type]} "

      print "#{bg}#{piece}\e[0m"

      if i % 8 == 7
        puts " #{8 - i / 8}"
        row += 1
      end
    end

    puts '   a  b  c  d  e  f  g  h'
  end

  def take_turn(start_square, end_square)
    active_piece = @board[hash(start_square)]
    if active_piece.nil? || active_piece.color != @active_player
      puts 'Invalid move, starting square needs to contain one of your pieces.'
      return
    end
    unless legal_moves(active_piece, active_piece.color).include?(end_square)
      puts 'Invalid move, the selected piece does not move like that.'
      return
    end
    if move_piece(start_square, end_square)
      @active_player = @active_player == :w ? :b : :w
      @half_moves += 1
      @turn += 1 if @active_player == :w
    else
      puts 'Invalid move, your king cannot be in check after your turn.'
    end

    puts 'Check.' if check?(active_piece.color)
  end

  # checks if the given player is checking the opponent's king
  def check?(player)
    if player == :w
      player_pieces = @whites
      opponent_king = @black_king
    else
      player_pieces = @blacks
      opponent_king = @white_king
    end

    player_pieces.any? { |piece| find_threats(piece, player).include?(opponent_king.square) }
  end

  private

  def populate_board(string)
    string = string.split(' ')[0].split('/').join('')
    index = 0
    string.each_char do |char|
      if char.match?(/[[:alpha:]]/)
        new_piece = Piece.new(char, index)
        new_piece.color == :w ? @whites << new_piece : @blacks << new_piece
        @board << new_piece
        if new_piece.type == :k
          if new_piece.color == :w
            @white_king = new_piece
          else
            @black_king = new_piece
          end
        end
        index += 1
      else
        n = char.to_i
        n.times { @board << nil }
        index += n
      end
    end
  end

  def find_threats(piece, player)
    if piece.threats[:type] == :iter
      iter_moves(piece, piece.threats[:list], player)
    else
      single_moves(piece, piece.threats[:list], player)
    end
  end

  def legal_moves(piece, player)
    if piece.moves[:type] == :iter
      iter_moves(piece, piece.moves[:list], player)
    elsif piece.type == :p
      moves = single_moves(piece, piece.moves[:list], player)
      piece.threats[:list].each do |threat|
        square = [piece.square[0] + threat[0], piece.square[1] + threat[1]]
        moves << square if @board[hash(square)].instance_of?(Piece) && @board[hash(square)].color != @active_player
      end
      moves
    else
      single_moves(piece, piece.moves[:list], player)
    end
  end

  def iter_moves(piece, steps, player)
    moves = []
    steps.each do |step|
      move = piece.square
      loop do
        move = [move[0] + step[0], move[1] + step[1]]
        break unless move_valid?(move, player)

        moves << move

        break if taking?(move, player)
      end
    end
    moves
  end

  def single_moves(piece, steps, player)
    moves = []
    steps.each do |step|
      move = [step[0] + piece.square[0], step[1] + piece.square[1]]
      moves << move if move_valid?(move, player)
    end
    moves
  end

  def taking?(move, player)
    if player == :w
      @blacks.any? { |piece| piece.square == move }
    else
      @whites.any? { |piece| piece.square == move }
    end
  end

  def move_valid?(move, player)
    move.all? { |coord| coord <= 7 && coord >= 0 } &&
      if player == :w
        @whites.none? { |piece| piece.square == move }
      else
        @blacks.none? { |piece| piece.square == move }
      end
  end

  def move_piece(start_square, end_square)
    piece = @board[hash(start_square)]
    target_piece = @board[hash(end_square)]
    @board[hash(end_square)] = piece
    @board[hash(start_square)] = nil
    opponent = @active_player == :w ? :b : :w

    return true unless check?(opponent)

    @board[hash(start_square)] = piece
    @board[hash(end_square)] = target_piece
    false
  end

  def hash(coords)
    coords[0] * 8 + coords[1]
  end
end
