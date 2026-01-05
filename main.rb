require_relative 'lib/hangman'

play_again = true

while play_again
  hangman = Hangman.new

  puts 'Would you like to load your last game? Y or N'
  hangman.load_game if gets.chomp.upcase == 'Y'

  until hangman.game_over? || hangman.turns_left.zero?
    puts 'Save game? Y or N'
    if gets.chomp.upcase == 'Y'
      hangman.save_game
      puts "\n\n\n\n\n\n"
    end
    hangman.show_guesses
    guess_right = hangman.take_turn
    puts "\n\n\n"
    hangman.turns_left -= 1 unless guess_right
  end

  if hangman.turns_left.zero?
    puts 'Ran out of turns! Game Over!'
  else
    puts 'Congrats! You won!'
  end

  hangman.reveal_word

  puts 'Play again? Y or N'
  choice = gets.chomp.upcase
  play_again = choice == 'Y'
end
