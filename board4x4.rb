class Board
  attr_reader :grid
  attr_accessor :letter
  def initialize
    @grid = [
      [' 0', ' 1', ' 2', ' 3'],
      [' 4', ' 5', ' 6', ' 7'],
      [' 8', ' 9', '10', '11'],
      ['12', '13', '14', '15']
    ]
  end

  def set_board
    @grid.each_with_index do |row, i|
      print "| "
      row.each { |cell| print "#{cell} | " }
      puts "\n---------------------
      " unless i == 3
    end
  end

  def has_won
    horizontal_win? || vertical_win? || diagonal_win?
  end

  def winning_move(letter)
    row_winnable(letter) + column_winnable(letter) + diagonal_winnable(letter)
  end

  def mark_position(position, letter)
    position = position.to_s
    location = BOARD_MAP[position]
    claim_position(location, letter)
  end

  def claim_position(position, letter)
    @grid[position[0]][position[1]] = letter
  end

  def flat
    @grid.flatten
  end

  def letter_locations(letter)
    flat.each_index.select{|i| flat[i] == 'X'}
  end

  def corner_position(letter)
    corner_positions.select{|pos| flat[pos] == letter }.first
  end

  def corner_positions
    [0,3,12,15]
  end

  def corner_available?
    corner_positions.any?{|corner| is_empty?(corner) }
  end

  def opposite_corner(corner)
    corner = corner.to_s
    corner_map = {"0" => "15", "15" => "0", "3" => "12", "12" => "3"}
    corner_map[corner]
  end

  def empty_next_to(positions)
    empty_adjacent_positions = positions.map do |pos|
      pos = pos.to_s
      y,x = BOARD_MAP[pos]

      above = [y - 1,x]
      below = [y + 1,x]
      left = [y,x - 1]
      right = [y,x + 1]

      all_adj = [above,below,left,right]
      adjacent = all_adj.reject { |a,b| a < 0 || b < 0 || a > 3 || b > 3 }
      adjacent.select { |a,b| is_empty?(xy_to_pos(a,b)) }
    end
    empty_adjacent_positions.flatten.sample
  end

  def xy_to_pos(x,y)
    BOARD_MAP.key([x,y])
  end

  def is_empty?(pos)
    !["X", "O"].include?(position(pos))
  end

  def position(i)
    i = i.to_i
    flat[i]
  end

  BOARD_MAP = {
    "0" => [0, 0],
    "1" => [0, 1],
    "2" => [0, 2],
    "3" => [0, 3],
    "4" => [1, 0],
    "5" => [1, 1],
    "6" => [1, 2],
    "7" => [1, 3],
    "8" => [2, 0],
    "9" => [2, 1],
    "10" => [2, 2],
    "11" => [2, 3],
    "12" => [3, 0],
    "13" => [3, 1],
    "14" => [3, 2],
    "15" => [3, 3]
  }

  private

  def diagonal_winnable(letter)
    response = []
    unless win_position(top_diagonal, letter).nil?
      response << [win_position(top_diagonal, letter), win_position(top_diagonal, letter)]
    end
    unless win_position(bottom_diagonal, letter).nil?
      response << [win_position(bottom_diagonal, letter), 3 - win_position(bottom_diagonal, letter)] #SHOULD THIS BE 3 or original 2?
    end
    response
  end

  def column_winnable(letter)
    response = []
    (0..3).each do |i|
      unless win_position(column(i), letter).nil?
        response << [win_position(column(i), letter), i]
      end
    end
    response
  end

  def row_winnable(letter)
    response = []
    @grid.each_with_index do |row, i|
      unless win_position(row, letter).nil?
        response << [i, win_position(row, letter)]
      end
    end
    response
  end

  def column(i)
    @grid.map { |row| row[i] }
  end

  def top_diagonal
    diagonal = []
    (0..3).each do |d|
      diagonal << @grid[d][d]
    end
    diagonal
  end

  def bottom_diagonal
    diagonal = []
    (0..3).each do |i|
      diagonal << @grid[i][3 - i]
    end
    diagonal
  end

  def horizontal_win?
    @grid.each do |row|
      if row.uniq.size == 1
        return true
      end
    end
    false
  end

  def vertical_win?
    (0..3).each do |i|
      if @grid[0][i] == @grid[1][i] && @grid[0][i] == @grid[2][i] && @grid[0][i] == @grid[3][i] # DOES THIS WORK?
        return true
      end
    end
    false
  end

  def diagonal_win?
    if @grid[0][0] == @grid[1][1] && @grid[0][0] == @grid[2][2] && @grid[0][0] == @grid[3][3]
      return true
    end
    if @grid[0][3] == @grid[1][2] && @grid[0][3] == @grid[2][1] && @grid[0][3] == @grid[3][0]
      return true
    end
    false
  end

  def win_position(array, letter)
    (0..3).each do |i|
      temp_array = array.dup #don't mess up our original row
      temp_array.delete_at(i) #take the element in question out of the row
      if temp_array.uniq.size == 1 && temp_array.uniq[0] == letter #if everything left in the row is the same
        if !(array[i] =~ /\d/).nil? #and if the element in question is a digit
          return i #return the coordinates of the element in question
        end
      end
    end
    nil
  end
end
