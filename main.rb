require_relative 'lib/board'

board = Board.new('rnbqkbnr/ppp1pppp/8/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 1 0')
board.display_board
board.take_turn([3, 4], [2, 3])
board.display_board
