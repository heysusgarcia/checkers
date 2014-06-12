class Piece

  attr_accessor :king, :position
  attr_reader :color, :board

  RED_VECTORS = [[1, 1], [1, -1]]
  BLACK_VECTORS = [[-1, 1], [-1, -1]]

  def initialize(color, board, pos)
    @board = board
    @color = color
    @position = pos
    @king = false
  end

  def perform_slide
  end

  def perform_jump
  end

  def moves
  end
  
  def sliding_moves
    moves = []
    steps = color == :r ? RED_VECTORS : BLACK_VECTORS
    steps.each do |step|
      row_step, col_step = step
      curr_row, curr_col = position
      new_row, new_col = (curr_row + row_step), (curr_col + col_step)
      if @board.in_range?(new_row, new_col) && @board(new_row, new_col).nil?
        moves << [new_row, new_col]
      end
    end 
    moves
  end

  
  def jumping_moves
    moves = []
    steps = color == :r ? RED_VECTORS : BLACK_VECTORS 
    
    steps.each_with_index do |step|
      row_step, col_step = step
      curr_row, curr_col = position
      neigh_row, neigh_col = (curr_row + row_step), (curr_col + col_step)
      neigh_tile = @board[neigh_row, neigh_col]
      next if neigh_tile.nil?
      next if neigh_tile.color == color
      
      jump_row, jump_col = (neigh_row + row_step), (neigh_col + col_step)
      if @board[jump_row, jump_col].nil? && @board.in_range?(jump_row, jump_col)
        moves << [jump_row, jump_col] 
      end
    end
    moves
  end
  
  def king?
    @king
  end
  
  def promote?
  end




end