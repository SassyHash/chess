# coding:utf-8 vi:et:ts=2
require 'debugger'

class Chess
  SIZE = 8
  COLORS = [:black, :white]

  attr_accessor :board

	def initialize
    @board = Chess.make_board
    populate_board

  end

  def play
    # assign_players
    player1 = HumanPlayer.new("White Player", :white)
    player2 = HumanPlayer.new("Black Player", :black)
    while true
      print_board
      move(player1.get_move)
      print_board
      move(player2.get_move)
    end
  end

  def on_board?(coords)
    coords.each do |array|
      array.each {|int| return false if !(0..SIZE-1).include?(int) }
    end
    return true
  end

  def move(coordinates_array)
    origin, destination = coordinates_array[0], coordinates_array[1]
    origin_tile, desti_tile = @board[origin[0]][origin[1]], @board[destination[0]][destination[1]]

    if on_board?(coordinates_array) && origin_tile.valid_move?(coordinates_array)
      @board[destination[0]][destination[1]], @board[origin[0]][origin[1]] = @board[origin[0]][origin[1]], @board[destination[0]][destination[1]]
      origin_tile.coordinates = destination
    else
      puts "Please give me valid coordinates!"
    end
    # # @board[origin[0]][origin[1]].valid?(coordinates_array)
    # p origin_tile, desti_tile
    # origin_tile, desti_tile = desti_tile, origin_tile
  end

  def populate_board
    populate_pawns(:black)
    populate_pawns(:white)
    populate_other_pieces(:black)
    populate_other_pieces(:white)
  end

  def populate_other_pieces(color)
    (color == :white) ? (row = 7) : (row = 0)
    @board[row][0] = Rook.new(color, [row, 0])
    @board[row][7] = Rook.new(color, [row, 7])
    @board[row][1] = Knight.new(color, [row, 1])
    @board[row][6] = Knight.new(color, [row, 6])
    @board[row][2] = Bishop.new(color, [row, 2])
    @board[row][5] = Bishop.new(color, [row, 5])
    @board[row][3] = King.new(color, [row, 3])
    @board[row][4] = Queen.new(color, [row, 4])

  end

  def populate_pawns(color)
    color == :black ? row = 1: row = 6
    # debugger
    SIZE.times do |col|
      @board[row][col] = Pawn.new(color, [row, col])
    end
  end

  # def assign_players
  #   @player1 = HumanPlayer.new
  #   puts "Would you like to play against? (H)uman or (C)omputer"
  #   answer = gets.chomp.upcase
  #   answer == "H" ? @player2 = HumanPlayer.new : @player2= ComputerPlayer.new
  # end

  def self.make_board
    Array.new(SIZE) {Array.new(SIZE)}
  end

  def print_board
    print "  "
    (0..(SIZE-1)).each {|num| print "#{(num)} "}
    puts ""
    @board.each_with_index do |row, row_i|
      print "#{(row_i)} "
      (0..(SIZE-1)).each do |tile_i|
        representation = " "
        representation = row[tile_i].symbol if row[tile_i] != nil
        print "#{representation} "
      end
      puts
    end
  end
end


class Piece
  attr_accessor :symbol, :coordinates
  def initialize(color, coordinates)
    @color = color
    @coordinates = coordinates
  end

end

class Pawn < Piece
  def initialize(color, coordinates)
    super(color, coordinates)
    color == :black ? @symbol = "\u265F" : @symbol = "\u2659"
  end

  def valid_move?(coordinates_array)
    origin, destination = coordinates_array[0], coordinates_array[1]
    return true if (@color == :black) && (origin[0] == destination[0] - 1)
    return true if (@color == :white) && (origin[0] == destination[0] + 1)
    return false
  end

end

class Rook < Piece
  def initialize(color, coordinates)
    super(color, coordinates)
    color == :black ? @symbol = "\u265C" : @symbol = "\u2656"
  end

  def valid_move?(coordinates_array)
   
  end
end

class Knight < Piece
  def initialize(color, coordinates)
    super(color, coordinates)
    color == :black ? @symbol = "\u265E" : @symbol = "\u2658"
  end

  def valid_move?(coords)
    
  end
end

class Bishop < Piece
  def initialize(color, coordinates)
    super(color, coordinates)
    color == :black ? @symbol = "\u265D" : @symbol = "\u2657"
  end

  def valid_move?(coords)
    
  end
end

class King < Piece
  def initialize(color, coordinates)
    super(color, coordinates)
    color == :black ? @symbol = "\u265A" : @symbol = "\u2654"
  end

  def valid_move?(coords)
    
  end
end

class Queen < Piece
  def initialize(color, coordinates)
    super(color, coordinates)
    color == :black ? @symbol = "\u265B" : @symbol = "\u2655"
  end

  def valid_move?(coords)
    
  end
end

class Player
  attr_accessor :player_color, :player_name
  def initialize(name, color)
    @player_name, @player_color = name, color
  end
end

class HumanPlayer < Player
  def initialize(name, color)
    super(name, color)
  end

  def get_move
    move = []
    puts "#{@player_name}, Type the position of the piece you would like to move. (Row, Colum) e.g. 3,4."
    move << gets.chomp.split(",").map {|num| num.to_i}
    puts "Type the position you'd like to move your piece to."
    move << gets.chomp.split(",").map {|num| num.to_i}
  end

end

class ComputerPlayer <Player
  def initialize(name, color)
    super(name, color)
  end

end

def load_game
  puts "Do you want to load a saved game (y/n)?"
  if gets.chomp.downcase[0] == "y"
    print "Enter the filename: "
    filename = gets.chomp
    string = File.read(filename).chomp
    game = YAML::load(string)
  else
    game = Chess.new
    puts game
  end
  game.play
end # Opening a saved version of the game

def save_game(game)
  print "Enter a new filename to save game in: "
  filename = gets.chomp
  File.open(filename, "w") {|f| f.puts game.to_yaml}
end

load_game