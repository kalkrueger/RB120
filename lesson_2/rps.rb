class Move
  attr_accessor :value

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def >(other_move)
    other_move = other_move.value
    case @value
    when 'rock' then Rock.compare(other_move)
    when 'paper' then Paper.compare(other_move)
    when 'scissors' then Scissors.compare(other_move)
    when 'lizard' then Lizard.compare(other_move)
    when 'spock' then Spock.compare(other_move)
    end
  end

  def to_s
    @value
  end
end

class Rock < Move
  def self.compare(other_move)
    other_move == 'scissors' || other_move == 'lizard'
  end
end

class Paper < Move
  def self.compare(other_move)
    other_move == 'rock' || other_move == 'spock'
  end
end

class Scissors < Move
  def self.compare(other_move)
    other_move == 'paper' || other_move == 'lizard'
  end
end

class Lizard < Move
  def self.compare(other_move)
    other_move == 'paper' || other_move == 'spock'
  end
end

class Spock < Move
  def self.compare(other_move)
    other_move == 'scissors' || other_move == 'rock'
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = []
  end
end

class Human < Player
  def set_name
    @name = ''
    loop do
      puts "What is your name?"
      @name = gets.chomp
      break unless @name.empty?
      puts "You must enter a name!"
    end
  end

  def choose
    choice = ''
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, thats an invalid choice."
    end
    self.move = Move.new(choice)
    @history << @move
  end
end

class Computer < Player
  @@computer_characters =
    { 'R2D2' => [1, 0, 0, 0, 0],
      'Hal' => [2, 0, 10, 5, 5],
      'Chappie' => [1, 1, 1, 1, 1],
      'Sonny' => [5, 5, 5, 1, 1],
      'Number5' => [0, 0, 0, 1, 1] }

  def set_name
    @@choices = []
    @name = @@computer_characters.keys.sample
    Move::VALUES.each_with_index do |move, ind|
      @@computer_characters[@name][ind].times { @@choices << move }
    end
  end

  def choose
    self.move = Move.new(@@choices.sample)
    @history << @move
  end
  def display_name
    puts "Get ready! You will be playing #{name}!"
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
    human.score = 0
    computer.score = 0
  end

  def reset_game
    @computer = Computer.new
    human.score = 0
    computer.score = 0
    human.history = []
  end

  def display_welcome_message
    puts "Welcom to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing, goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    @winner = ''
    if human.move > computer.move
      @winner = human.name
    elsif computer.move > human.move
      @winner = computer.name
    end
    puts(@winner.empty? ? "It's a tie!" : "#{@winner} won!")
  end

  def keep_score
    if @winner == human.name
      human.score += 1
    elsif @winner == computer.name
      computer.score += 1
    end
  end

  def display_score
    puts "#{human.name} has won #{human.score} game(s)."
    puts "#{computer.name} has won #{computer.score} games(s)."
  end

  def display_history(player)
    puts "-----"
    puts "#{player.name}:"
    player.history.each_with_index do |move, ind|
      puts "Move #{ind + 1}: #{move}"
    end
    puts "-----"
  end

  def match_over?
    return false unless human.score == 5 || computer.score == 5
    @match_winner = (human.score == 5 ? human.name : computer.name)
    puts "#{@match_winner} won the match!"
    true
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play agian? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, input must be y or n."
    end
    return true if answer == 'y'
    false
  end

  def game_play
    loop do
      computer.display_name
      human.choose
      computer.choose
      display_moves
      display_winner
      keep_score
      display_score
      break if match_over?
    end
  end

  def match_play
    loop do
      game_play
      display_history(human)
      display_history(computer)
      break unless play_again?
      reset_game
    end
    display_goodbye_message
  end
end

RPSGame.new.match_play
