require 'pry'
class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts ""
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
    puts ""
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def get_square_at(key)
    @squares[key]
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_combo?(squares, player_marker)
    return false if squares.all? { |sqr| sqr.marker == Square::INITIAL_MARKER }
    squares.collect(&:marker).count(player_marker)
  end

  def get_marker(key)
    @squares[key].marker
  end

  def ai_defense(opponent_marker)
    WINNING_LINES.select do |line|
      if winning_combo?(@squares.values_at(*line), opponent_marker) == 2
        line.each { |key| return key if @squares[key].unmarked? }
      end
    end
    nil
  end

  def ai_offense(computer_marker)
    WINNING_LINES.select do |line|
      if winning_combo?(@squares.values_at(*line), computer_marker) == 2
        line.each { |key| return key if @squares[key].unmarked? }
      end
    end
    nil
  end

  def center_open?
    get_marker(5) == Square::INITIAL_MARKER
  end

  def winning_marker
    WINNING_LINES.each do |line|
      if winning_combo?(@squares.values_at(*line), get_marker(line[0])) == 3
        return get_marker(line[0])
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :name

  def set_human_name
    @name = ''
    loop do
      puts "What is your name?"
      @name = gets.chomp
      break unless @name.empty?
      puts "You must enter a name!"
    end
  end

  def set_human_marker
    @marker = ''
    loop do
      puts "Would you like to be X or O?"
      @marker = gets.chomp.upcase
      break if ['X', 'O'].include? marker
    end
  end
end

class TTTGame
  HUMAN_FIRST = true
  LOSER_FIRST = true
  TIE_SWITCHES_FIRST = true
  @@first_turn = nil
  @@player_turn = nil
  @@human_wins = 0
  @@computer_wins = 0
  attr_reader :board, :human, :computer

  def initialize
    clear
    display_welcome_message
    @board = Board.new
    @human = Player.new
    @computer = Player.new
    set_names_and_markers
  end

  def play
    clear
    loop do
      display_board
      player_move
      display_result
      break unless play_again
      switch_first
    end
    display_goodbye_message
  end

  private

  def set_names_and_markers
    human.set_human_name
    human.set_human_marker
    computer.name = "R2D2"
    computer.marker = (human.marker == 'X' ? 'O' : 'X')
  end

  def player_move
    loop do
      current_player_move
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_move?
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ''
  end

  def display_goodbye_message
    puts ''
    puts "Thanks for playing! Goodbye!"
  end

  def display_choices
    if board.unmarked_keys.size > 1
      "#{board.unmarked_keys[0..-2].join(', ')} or #{board.unmarked_keys.last}"
    else
      board.unmarked_keys[0].to_s
    end
  end

  def human_move
    choice = nil
    loop do
      puts "Please choose " + display_choices
      choice = gets.chomp.to_i
      break if board.unmarked_keys.include?(choice)
      puts "Choose an available space!"
    end
    board[choice] = human.marker
    @@player_turn = computer.marker
  end

  def ai_choices
    ai_choice = board.ai_offense(computer.marker)
    ai_choice = board.ai_defense(human.marker) if ai_choice.nil?
    ai_choice = 5 if !!board.center_open? && ai_choice.nil?
    ai_choice
  end

  def computer_move
    choice = ai_choices
    choice = board.unmarked_keys.sample if choice.nil?
    board[choice] = computer.marker
    @@player_turn = human.marker
  end

  def human_move?
    @@player_turn = @@first_turn if @@player_turn.nil?
    if @@player_turn.nil?
      @@player_turn = (HUMAN_FIRST ? human.marker : computer.marker)
    end
    @@player_turn == human.marker
  end

  def loser_first
    @@first_turn = if board.winning_marker == human.marker
                     computer.marker
                   else
                     human.marker
                   end
  end

  def switch_on_tie
    @@first_turn = if @@first_turn == human.marker
                     computer.marker
                   else
                     human.marker
                   end
  end

  def switch_first
    @@player_turn = nil
    loser_first if LOSER_FIRST && board.someone_won?
    switch_on_tie if TIE_SWITCHES_FIRST && !board.someone_won?
  end

  def current_player_move
    !!human_move? ? human_move : computer_move
  end

  def display_score
    case board.winning_marker
    when human.marker
      @@human_wins += 1
    when computer.marker
      @@computer_wins += 1
    end
    puts "#{human.name} has won #{@@human_wins} time(s)"
    puts "#{computer.name} has won #{@@computer_wins} time(s)"
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
    display_score
  end

  def display_play_again_message
    board.reset
    clear
    puts "Let's play again!"
    puts ''
  end

  def play_again
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include?(answer) && !answer.empty?
      puts "You must answer y or n"
    end
    return false if answer == 'n'
    display_play_again_message
    true
  end

  def clear
    system 'clear'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're an #{human.marker}"
    puts "#{computer.name} is an #{computer.marker}"
    board.draw
  end
end

game = TTTGame.new
game.play
