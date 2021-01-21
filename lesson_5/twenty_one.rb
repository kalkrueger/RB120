class Participant
  attr_accessor :hand, :wins
  attr_reader :name

  def initialize
    @hand = []
    @wins = 0
  end

  def busted?
    score > 21
  end

  def sort_by_value(cards)
    cards.sort_by(&:value).reverse
  end

  def total(cards)
    running_total = 0
    sort_by_value(cards).each do |card|
      running_total += card.optimize_value(running_total)
    end
    running_total
  end

  def score
    @score = total(hand)
  end

  def display_total
    puts "#{name} is at #{score}"
    puts ''
  end

  def show_card(card)
    puts "----------"
    puts card.face.center(10)
    puts "of".center(10)
    puts card.suit.center(10)
    puts "----------"
  end

  def show_hand
    puts "#{name}'s Hand:"
    hand.each { |card| show_card(card) }
    puts ''
  end

  def stayed?
    @last_play == 's'
  end

  def display_wins
    puts "#{name} has won #{wins} game(s)."
  end
end

class Player < Participant
  def initialize
    super
    @name = set_name
  end

  def set_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "You must enter a name!"
    end
    name
  end

  def hit?
    answer = ''
    loop do
      puts "Would you like to hit or stay? (h/s)"
      answer = gets.chomp.downcase
      break if ['h', 's'].include? answer
      puts "You must choose 'h' or 's'!"
    end
    @last_play = answer
    answer == 'h'
  end
end

class Dealer < Participant
  def initialize
    super
    @name = "Dealer"
  end

  def hit?
    @last_play = if score < 17
                   'h'
                 else
                   's'
                 end
    @last_play == 'h'
  end

  def showing
    hand[1..-1]
  end

  def hide_first_card_display
    puts "#{name}'s Hand:"
    puts "----------"
    puts "Face".center(10)
    puts "Down".center(10)
    puts "---------"
    showing.each { |card| show_card(card) }
    puts ''
  end

  def display_showing_total
    puts "#{name} is showing #{total(showing)}"
    puts ''
  end
end

class Deck
  attr_reader :cards

  def initialize
    create_deck
    cards.shuffle!
  end

  def create_deck
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |face, value|
        @cards << Card.new(suit, face, value)
      end
    end
  end

  def deal
    cards.pop
  end
end

class Card
  attr_reader :suit, :face, :value

  SUITS = %w(Clubs Diamonds Hearts Spades)
  VALUES = { 'Ace' => 1, 'Two' => 2, 'Three' => 3, 'Four' => 4, 'Five' => 5,
             'Six' => 6, 'Seven' => 7, 'Eight' => 8, 'Nine' => 9, 'Ten' => 10,
             'Jack' => 10, 'Queen' => 10, 'King' => 10 }

  def initialize(suit, face, value)
    @suit = suit
    @face = face
    @value = value
  end

  def optimize_value(total)
    if value == 1 && total < 11
      11
    else
      value
    end
  end
end

class Game
  attr_reader :deck, :player, :dealer

  def start
    loop do
      deal_cards
      show_in_game_cards
      game_play
      keep_score
      show_result
      break unless play_again?
      reset
    end
    display_goodbye_message
  end

  private

  def initialize
    clear
    display_welcome_message
    @player = Player.new
    @dealer = Dealer.new
    new_deck
  end

  def display_welcome_message
    puts "Welcome to Twenty-One! Good luck!"
  end

  def clear
    system 'clear'
  end

  def new_deck
    @deck = Deck.new
  end

  def game_play
    loop do
      player_turn
      dealer_turn
      break if game_over?
      show_in_game_cards
    end
  end

  def deal_cards
    2.times do
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def show_in_game_cards
    clear
    display_participants_wins
    dealer.hide_first_card_display
    player.show_hand
    show_current_scores
  end

  def show_current_scores
    dealer.display_showing_total
    player.display_total
  end

  def player_turn
    player.hand << deck.deal if player.hit?
  end

  def dealer_turn
    dealer.hand << deck.deal if dealer.hit?
  end

  def game_over?
    return true if player.busted? || dealer.busted?
    return true if player.stayed? && dealer.stayed?
    false
  end

  def show_result
    clear
    display_participants_wins
    dealer.show_hand
    player.show_hand
    show_final_scores
    display_winner
  end

  def show_final_scores
    dealer.display_total
    player.display_total
  end

  def tie?
    player.busted? && dealer.busted? || player.score == dealer.score
  end

  def win_on_bust
    if player.busted?
      dealer.name
    elsif dealer.busted?
      player.name
    end
  end

  def display_bust
    if player.busted? && dealer.busted?
      puts "Both players busted!"
    elsif player.busted?
      puts "#{player.name} busted!"
    elsif dealer.busted?
      puts "#{dealer.name} busted!"
    end
  end

  def determine_winner
    if tie?
      nil
    elsif win_on_bust
      win_on_bust
    else
      player.score > dealer.score ? player.name : dealer.name
    end
  end

  def display_winner
    display_bust
    if @winner.nil?
      puts "It's a tie!"
    else
      puts "#{@winner} won!"
    end
    puts ''
  end

  def keep_score
    @winner = determine_winner
    case @winner
    when @player.name
      @player.wins += 1
    when @dealer.name
      @dealer.wins += 1
    end
  end

  def display_participants_wins
    player.display_wins
    dealer.display_wins
    puts ''
  end

  def play_again?
    answer = ''
    loop do
      puts "Would you like to keep playing? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "You must choose y or n!"
    end
    answer == 'y'
  end

  def reset
    player.hand = []
    dealer.hand = []
    new_deck
  end

  def display_goodbye_message
    puts ''
    puts "Thanks for playing Twenty-One! Goodbye!"
    puts ''
  end
end

Game.new.start
