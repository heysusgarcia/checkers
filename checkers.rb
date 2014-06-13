require './board.rb'
require './piece.rb'
require './human_player.rb'
require './invalid_move_errors.rb'

class Game
  
  attr_reader :player1, :player2, :board, :turn
  
  def initialize(player1, player2)
    @board = Board.new
    @board.setup_board
    @player1 = Player.new(player1, :b)
    @player2 = Player.new(player2, :r)
    @turn = :b 
  end  
  
  def play
    
    puts "Let's play some Checkers!"
    
    until won?(:r) || won?(:b)
      
      begin
      player = @turn == :b ? player1 : player2
      
      puts "#{player.name}, it is your turn. You are #{player.color}."
      puts "please begin by enter starting position as follows 01"
      start_pos = get_start_pos 
      
      puts "Please enter your move sequence as follows 01 12 ..."
      move_seq = get_move_seq
      
      piece = @board[start_pos[0], start_pos[1]]
      piece.perform_moves(move_seq)
    rescue InvalidMoveError =>
      puts e
      retry
    end
    @turn = @turn == :b ? :r : :b
    end
  end
  
  def get_start_pos
    input = gets.chomp.split(" ").split("").map { |arr| arr.map { |i| i.to_i} }
  end
  
  def get_move_seq
    input = gets.chomp.split(" ").split("").map { |arr| arr.map { |i| i.to_i} }
  end
  
  def won?(color) #
    opponent = color == :r ? :b : :r
    opponent_pieces = @board.get_pieces(opponent)
    
    if opponent_pieces.empty?
      true
    else 
      opponent_pieces.none? do |piece| 
        piece.sliding_moves || piece.jumping_moves
      end
    end
  end
  
   
  # def play_in_turn?(player, turn)
  #   play_in_turn = player.color == @turn
  #   raise InvalidMoveError.new "NOT YO PIECE!"
  # end
  
end

if __FILE__ == $PROGRAM_NAME
  checkers = Game.new("Jesus", "Jeremy")
  checker.play
end