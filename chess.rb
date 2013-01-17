# coding:utf-8 vi:et:ts=2
class Chess
  SIZE = 8
  COLORS = [:black, :white]

  attr_accessor :board

	def initialize
    @board = Chess.make_board
    populate_board
  end

  def play
    print_board
  end

  def populate_board
    populate_pawns(:black)
    populate_pawns(:white)
    populate_other_pieces(:black)
    populate_other_pieces(:white)
  end

  def populate_other_pieces(color)
    (color == :white) ? (row = 7) : (row = 0)
    @board[row][0] = Rook.new(color)
    @board[row][7] = Rook.new(color)
    @board[row][1] = Knight.new(color)
    @board[row][6] = Knight.new(color)
    @board[row][2] = Bishop.new(color)
    @board[row][5] = Bishop.new(color)
    @board[row][3] = King.new(color)
    @board[row][4] = Queen.new(color)

  end

  def populate_pawns(color)
    color == :black ? row = 1: row = 6
    @board[row] = @board[row].map{Pawn.new(color)}
  end

  def assign_players
    puts "Would you like to play with 2 humans?"
    answer = gets.chomp
  end

  def self.make_board
    Array.new(SIZE) {Array.new(SIZE, " ")}
    # puts "about to"
    # populate_board
    # puts "done populating"
  end

  def print_board
    (0..(SIZE-1)).each {|num| print "#{(num)}    "}
    puts
    (0..(SIZE-1)).each do |num|
      puts "#{num+1} #{@board[num].symbol}"
    end
    puts "board: #{@board}"
    @board[2].each { |objID| puts "Object ID #{objID.inspect}" }
  end
end


class Piece
  attr_accessor :symbol
  def initialize(color)
    @color = color
  end

end

class Pawn < Piece
  def initialize(color)
    super(color)
    color == :black ? @symbol = "\u265F" : @symbol = "\u2659"
  end

end

class Rook < Piece
  def initialize(color)
    super(color)
    color == :black ? @symbol = "\u265C" : @symbol = "\u2656"
  end

end

class Knight < Piece
  def initialize(color)
    super(color)
    color == :black ? @symbol = "\u265E" : @symbol = "\u2658"
  end
end

class Bishop < Piece
  def initialize(color)
    super(color)
    color == :black ? @symbol = "\u265D" : @symbol = "\u2657"
  end
end

class King < Piece
  def initialize(color)
    super(color)
    color == :black ? @symbol = "\u265A" : @symbol = "\u2654"
  end
end

class Queen < Piece
  def initialize(color)
    super(color)
    color == :black ? @symbol = "\u265B" : @symbol = "\u2655"
  end
end

class Player
end

class HumanPlayer < Player
#give moves
end

class ComputerPlayer <Player

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