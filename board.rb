require './piece.rb'
require 'colorize'

class Board
  
  attr_reader :board
  
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end
  
  def setup_board
    0.upto(7).each do |col|
      @board[0][col] = Piece.new(:r, @board,[0, col]) unless col.even?
      @board[1][col] = Piece.new(:r, @board,[1, col]) unless col.odd?
      @board[2][col] = Piece.new(:r, @board,[2, col]) unless col.even?

      @board[5][col] = Piece.new(:b, @board, [5, col]) unless col.odd?
      @board[6][col] = Piece.new(:b, @board, [6, col]) unless col.even?
      @board[7][col] = Piece.new(:b, @board, [7, col]) unless col.odd?
    end    
  end
  

  def [](row, col)
    @board[row][col]
  end

  def []=(row, col, piece)
    @board[row][col] = piece
  end
  
  def dup
    dup_board = Board.new
    
    dup_board.board.each_with_index do |row, indx1|
      row.each_with_index do |piece, indx2|
        next if piece.nil?
        new_piece = Piece.new(piece.color, dup_board, piece.position)
        new_piece.king = true if piece.king
        dup_board[indx1, indx2] = new_piece
      end
    end
    dup_board
  end
  
  def in_range?(row, col)
    (row >= 0 && row < 8) && (col >= 0 && col < 8)
  end
  
  def display
    print render
  end

  def render
    0.upto(7).each do |row|
      0.upto(7).each do |col|
        tile = @board[row][col]
        str = tile.nil? ? "   " : " #{tile.color} "
        print colorize_board(str, row + col)
      end
      puts "\n"    
    end
  end

  def colorize_board(str, num)
    if num.even? 
      return str.colorize( :color => :white, :background => :red ) 
    else
      return str.colorize( :color => :white, :background => :black )
    end
  end



end


# p board = Board.new
# p board.render
# r = Piece.new(:r, b, [2, 3])
# b1 = Piece.new(:b, b, [3, 2])
# b2 = Piece.new(:b, b, [3, 4])
# b[2, 3] = r; b[3, 2] = b1; b[3, 4] = b2
# p board.render

