# encoding: utf-8
require './board.rb'
class Piece

  attr_accessor :king, :position
  attr_reader :color, :board, :symbol

  RED_VECTORS = [[1, 1], [1, -1]]
  BLACK_VECTORS = [[-1, 1], [-1, -1]]
  # SYMBOLS = { r:  "\u25c9".colorize( :color => :red), 
  #             b:  "\u25c9".colorize( :color => :black) }

  def initialize(color, board, pos)
    @board = board
    @color = color
    @position = pos
    # @symbol = SYMBOLS[@color]
    @king = false
  end
  
  def valid_move_seq?(moves)
    dup_board = @board.deep_dup
    dup_piece = dup_board[position[0], position[1]]
    begin
      dup_piece.perform_moves!(moves)
    rescue InvalidMoveError
      false
    else
      true
    end
  end
  
  def perform_moves(moves)
    if valid_move_seq?(moves)
      perform_moves!(moves)
    else
      raise InvalidMoveError.new "Move sequence isn't valid"
    end
  end
  
  def perform_moves!(moves)
    if moves.count == 1
      moved = perform_slide(moves[0]) || perform_jump(moves[0])  
      raise InvalidMoveError.new "Move sequence isn't valid" unless moved
    else 
      moves.each do |move| 
        moved = perform_jump(move)
        raise InvalidMoveError.new "Move sequence isn't valid" unless moved
      end
    end 
    true
  end
  
  def perform_slide(new_pos)
    return false if !sliding_moves.include?(new_pos)
    curr_row, curr_col = self.position
    @board[new_pos[0], new_pos[1]] = self
    self.position = new_pos
    @board[curr_row, curr_col] = nil
    maybe_promote
    true
  end

  def perform_jump(new_pos)
    return false if !jumping_moves.include?(new_pos)
    curr_row, curr_col = self.position
    jumped_row = ((curr_row + new_pos[0]) / 2 )  
    jumped_col = ((curr_col + new_pos[1]) / 2 )
    @board[new_pos[0], new_pos[1]] = self
    self.position = new_pos
    @board[curr_row, curr_col] = nil
    @board[jumped_row, jumped_col] = nil
    maybe_promote
    true
  end

  def sliding_moves
    moves = []
    steps = move_diffs
    steps.each do |step|
      row_step, col_step = step
      curr_row, curr_col = position
      new_row, new_col = (curr_row + row_step), (curr_col + col_step)
      if @board.in_range?(new_row, new_col) && @board[new_row, new_col].nil?
        moves << [new_row, new_col]
      end
    end 
    moves
  end

  def jumping_moves
    moves = []
    steps = move_diffs
    steps.each do |step|
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
  
  def move_diffs
    if king? 
      RED_VECTORS + BLACK_VECTORS
    elsif color == :r 
      RED_VECTORS 
    else 
      BLACK_VECTORS
    end
  end
  
  def king?
    @king
  end
  
  def maybe_promote
    @king = true if color == :b && position[0] == 0
    @king = true if color == :r && position[0] == 7
  end
end