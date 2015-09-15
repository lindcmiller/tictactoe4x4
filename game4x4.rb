require './board4x4'
require './player4x4'
require './turn4x4'
require 'pry'

class Game
  attr_accessor :board, :set_board, :computer, :user, :letter, :first_player, :take_turn, :board_status, :has_won, :next_player

  def initialize
    @board = Board.new
  end

  def self.run
    game = Game.new
    user = Player.new("user")
    computer = Player.new("computer")

    if user.first_player == "y"
      active_player = user
      user.take_turn(game.board)
    else
      active_player = computer
      computer.take_turn(game.board)
    end

    turn_counter = 1
    while game.board.has_won == false && turn_counter < 16
      active_player = active_player.user == true ? computer : user
      active_player.take_turn(game.board)
      turn_counter += 1
    end

    # game over
    game.board.set_board
    if game.board.has_won == false
      puts "\n\nWe tied. I am undefeatable yet again."
    elsif game.board.has_won && active_player.computer == true
      puts "\n\nYOU LOSE."
    else
      puts "\n\nImprobably, you have won. This is not ideal. Good day."
    end

  end
end

Game.run
