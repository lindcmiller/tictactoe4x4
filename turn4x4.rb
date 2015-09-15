require './board4x4'
require './player4x4'
require 'pry'

class Turn
  attr_accessor :user_turn, :computer_turn, :winning_move, :board

  def self.take_turn(player, board)
    @board = board
    if player.user == true
      @board.set_board
      puts "\n\n Where would you like to play your letter?"
      position = gets.chomp
      if move_valid?(position)
        @board.mark_position(position, player.letter)
      else
        puts "\n NOPE. Try again. \n\n"
        self.take_turn(player, @board)
      end

    else
      computer_turn
    end
  end

  def self.move_valid?(position) # expects 0-15, match 1 or 2 characters, and place an X or O
    (position.to_i < 16) && !(/^[0-9]{1,2}$/.match(position)).nil? && (/^[OX]$/.match(@board.flat[position.to_i])).nil?
  end

  def self.computer_turn
# Win, if possible
    if can_win?('O')
      ai_win
 # Block, if opponent can win
    elsif can_win?('X')
      ai_block_opp
# Fork: Create an opportunity where you can win in two ways
    elsif about_to_get_fork?('O')
      take_empty_corner
# Block Opponent's Fork
    elsif about_to_get_fork?('X')
      make_opponent_block
# Opposite Corner: If the opponent is in the corner, play the opposite corner //// switch back to below center if needed
    elsif has_corner_and_opposite_is_empty?('X')
      corner = @board.corner_position('X')
      take_opposite_corner(corner)
# Center
    elsif @board.is_empty?(5)
      take_position("5")
    elsif @board.is_empty?(6)
      take_position("6")
    elsif @board.is_empty?(9)
      take_position("9")
    elsif @board.is_empty?(10)
      take_position("10")
# Empty Corner: Play an empty corner
    elsif @board.corner_available?
      take_empty_corner
# Empty Side: Play an empty side
    elsif @board.is_empty?(1)
      take_position("1")
    elsif @board.is_empty?(2)
      take_position("2")
    elsif @board.is_empty?(7)
      take_position("7")
    elsif @board.is_empty?(11)
      take_position("11")
    elsif @board.is_empty?(14)
      take_position("14")
    elsif @board.is_empty?(13)
      take_position("13")
    elsif @board.is_empty?(8)
      take_position("8")
    elsif @board.is_empty?(4)
      take_position("4")
    else
      puts "NOPE."
    end
  end

private

  class << self
    def can_win?(letter)
      !@board.winning_move(letter).empty?
    end

    def take_position(pos)
      @board.mark_position(pos, 'O')
    end

    def ai_win
      @board.claim_position(@board.winning_move('O').first, 'O')
    end

    def ai_block_opp
      @board.claim_position(@board.winning_move('X').first, 'O')
    end

    def has_corner?(letter)
      !@board.corner_position(letter).nil?
    end

    def take_empty_corner
      if @board.is_empty?(0)
        take_position("0")
      elsif @board.is_empty?(3)
        take_position("3")
      elsif @board.is_empty?(12)
        take_position("12")
      elsif @board.is_empty?(15)
        take_position("15")
      end
    end

    def take_opposite_corner(corner)
      take_position(@board.opposite_corner(corner))
    end

    def about_to_get_fork?(letter)
      corner = @board.corner_position(letter)
      opposite_value = @board.position(@board.opposite_corner(corner))
      !corner.nil? && opposite_value == letter
    end

    def has_corner_and_opposite_is_empty?(letter)
      corner = @board.corner_position(letter)
      !corner.nil? && @board.is_empty?(@board.opposite_corner(corner))
    end

    def make_opponent_block
      our_positions = @board.letter_locations('O')
      take_position(@board.empty_next_to(our_positions))
    end
  end

end

Turn.new
