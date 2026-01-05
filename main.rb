require_relative 'lib/hangman'

play_again = true

while play_again
  hangman = Hangman.new
  turns_left = 10

  until hangman.game_over? || turns_left.zero?
    guess_right = hangman.take_turn
    hangman.show_guesses
    turns_left -= 1 unless guess_right
  end

  if turns_left.zero?
    puts 'Ran out of turns! Game Over!'
  else
    puts 'Congrats! You won!'
  end

  hangman.reveal_word

  puts 'Play again? Y or N'
  choice = gets.chomp.upcase
  play_again = choice == 'Y'
end
