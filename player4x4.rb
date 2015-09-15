class Player
  attr_reader :computer, :user, :letter, :first_player, :grid, :turn

  def initialize(user_type)
    if user_type == "user"
      @computer = false
      @user = true
      @letter = "X"
    else
      @computer = true
      @user = false
      @letter = "O"
    end
  end

  def take_turn(board)
    Turn.take_turn(self, board)
  end

  def first_player
    puts "Would you like to make the first move? (y/n)"
    @first_player = gets.chomp
    while !(/^[yn]$/.match(@first_player))
      puts "\n NOPE. Simply not an option. \n\n"
      puts "Would you like to make the first move? (y/n)"
      @first_player = gets.chomp
    end
    @first_player
  end
end
