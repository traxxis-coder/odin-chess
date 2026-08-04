require 'colorize'

class Piece
  # SYMBOLS = {
  #   white: {
  #     r: "\u{2656}".colorize(:white),
  #     n: "\u{2658}".colorize(:white),
  #     b: "\u{2657}".colorize(:white),
  #     k: "\u{2654}".colorize(:white),
  #     q: "\u{2655}".colorize(:white),
  #     p: "\u{2659}".colorize(:white)
  #   },
  #   black: {
  #     r: "\u{265C}".colorize(:black),
  #     n: "\u{265E}".colorize(:black),
  #     b: "\u{265D}".colorize(:black),
  #     k: "\u{265A}".colorize(:black),
  #     q: "\u{265B}".colorize(:black),
  #     p: "\u{265F}".colorize(:black)
  #   }
  # }.freeze

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
  attr_reader :color, :type
  attr_accessor :square

  def initialize(piece, index)
    @color = piece == piece.upcase ? :white : :black
    @type = piece.downcase.to_sym
    @square = unhash(index)
  end

  private

  def unhash(index)
    row = index / 8 + 1
    col = index % 8 + 96
    col.chr + row.to_s
  end
end
