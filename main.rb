require_relative 'lib/board'

board = Board.new('2rk4/8/8/8/8/8/8/2K4 b - - 0 1')
puts board.check?(:b)
