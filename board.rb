# encoding: utf-8
require './piece.rb'
require 'colorize'

class Board
  
  attr_reader :board
  
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end
  
  def setup_board
    0.upto(7).each do |col|
      @board[0][col] = Piece.new(:r, self,[0, col]) unless col.even?
      @board[1][col] = Piece.new(:r, self,[1, col]) unless col.odd?
      @board[2][col] = Piece.new(:r, self,[2, col]) unless col.even?
                                       
      @board[5][col] = Piece.new(:b, self, [5, col]) unless col.odd?
      @board[6][col] = Piece.new(:b, self, [6, col]) unless col.even?
      @board[7][col] = Piece.new(:b, self, [7, col]) unless col.odd?
    end    
  end
  

  def [](row, col)
    @board[row][col]
  end

  def []=(row, col, piece)
    @board[row][col] = piece
  end
  
  def deep_dup
    dup_board = Board.new
    board.each_with_index do |row, indx1|
      row.each_with_index do |piece, indx2|
        next if piece.nil?
        puts "color: #{piece.color}"
        puts "piece instance of piece?: #{piece.is_a?(Piece)}"
        new_piece = Piece.new(piece.color, dup_board, piece.position)
        new_piece.king = true if piece.king?
        dup_board[indx1, indx2] = new_piece
      end
    end
    dup_board
  end
  
  def get_pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end
  
  def in_range?(row, col)
    (0..7).include?(row) && (0..7).include?(col)
    # (row >= 0 && row < 8) && (col >= 0 && col < 8)
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
