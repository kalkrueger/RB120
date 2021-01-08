class Player
  attr_accessor :move, :name
  @@moves = ['rock', 'paper', 'scissors']

  def initialize(player_type = :human)
    @player_type = player_type
    @move = nil
    set_name
  end

  def set_name
    @name = if human?
              n = nil
              loop do
                puts "What is your name?"
                n = gets.chomp
                break unless n.empty?
                puts "You must enter a name!"
              end
              n
            else
              "Computer"
            end
  end

  def choose
    if human?
      choice = nil
      loop do
        puts "Please choose rock, paper, or scissors"
        choice = gets.chomp
        break if  @@moves.include?(choice)
        puts "Sorry, thats an invalid choice."
      end
      self.move = choice
    else
      self.move = @@moves.sample
    end
  end

  def human?
    @player_type == :human
  end
end


class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new(:computer)
  end

  def display_welcome_message
    puts "Welcom to Rock, Paper, Scissors"
  end

  def display_goodbye_message
    puts "Thanks for playing, goodbye!"
  end

  def display_winner
    @@winner = false
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"

    case human.move
    when 'rock'
      @@winner = "#{human.name}" if computer.move == 'scissors'
      @@winner = "#{computer.name}" if computer.move == 'paper'
    when 'paper'
      @@winner = "#{human.name}" if computer.move == 'rock'
      @@winner = "#{computer.name}" if computer.move == 'scissors'
    when 'scissors'
      @@winner = "#{human.name}" if computer.move == 'paper'
      @@winner = "#{computer.name }"if computer.move == 'rock'
    end
    if @@winner
      puts "#{@@winner} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play agian? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, input must be y or n."
    end

    return true if answer == 'y'
    return false
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end

    display_goodbye_message
  end
end

RPSGame.new.play
