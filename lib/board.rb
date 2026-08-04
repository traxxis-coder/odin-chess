require_relative 'piece'

class Board
  attr_reader :board, :active_player

  def initialize(string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    @board = []
    populate_board(string)
    @active_player = string.split(' ')[1].to_sym
    @castling = string.split(' ')[2]
    @en_passant = string.split(' ')[3]
    @half_moves = string.split(' ')[4]
    @turn = string.split(' ')[5]
    display_board
  end

  # private

  def populate_board(string)
    string = string.split(' ')[0].split('/').join('')
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

  private

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
end
