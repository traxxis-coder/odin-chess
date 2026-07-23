class Piece
  attr_reader :color, :type
  attr_accessor :square

  def initialize(piece, index)
    @color = piece == piece.downcase ? :white : :black
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
