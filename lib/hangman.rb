require 'yaml'

class Hangman
  attr_accessor :hang_word, :right_guesses, :wrong_guesses, :turns_left

  def initialize(min = 5, max = 12)
    dict_file = IO.sysopen('./google-10000-english-no-swears.txt')
    dict_io = IO.new(dict_file)
    word_choices = []
    until dict_io.eof?
      word = dict_io.gets.chomp
      word_choices.push(word) if word.length >= min && word.length <= max
    end

    @hang_word = word_choices[rand(0...word_choices.length)]
    @right_guesses = '_' * hang_word.length
    @wrong_guesses = ''
    @turns_left = 10
  end

  def save_game(filename = 'save01.yaml')
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open("saves/#{filename}", 'w') do |file|
      file.write(to_yaml)
      file.close
    end
  end

  def load_game(filename = 'save01.yaml')
    save = File.open("saves/#{filename}", 'r')
    from_yaml(save)
    save.close
  end

  def to_yaml
    YAML.dump({
                hang_word: @hang_word,
                right_guesses: @right_guesses,
                wrong_guesses: @wrong_guesses,
                turns_left: @turns_left
              })
  end

  def from_yaml(string)
    data = YAML.load string
    @hang_word = data[:hang_word]
    @right_guesses = data[:right_guesses]
    @wrong_guesses = data[:wrong_guesses]
    @turns_left = data[:turns_left]
  end

  def reveal_word
    puts "The word was \"#{hang_word}\"!"
  end

  def show_guesses
    puts ''
    puts "Word revealed so far: \"#{right_guesses}\""
    puts "Wrong letters: \"#{wrong_guesses}\""
  end

  def guess_letter(letter)
    if hang_word.include?(letter)
      puts 'Correct!'
      (0...hang_word.length).each do |n|
        right_guesses[n] = letter if hang_word[n] == letter
      end
      true
    else
      puts 'Incorrect guess!'
      @wrong_guesses += letter
      false
    end
  end

  def take_turn
    print 'Guess a letter!: '
    guess = gets.chomp
    while guess.length != 1 || wrong_guesses.include?(guess) || right_guesses.include?(guess)
      while guess.length != 1
        print 'Incorrect input: Please enter a single letter: '
        guess = gets.chomp
      end
      while wrong_guesses.include?(guess) || right_guesses.include?(guess)
        print 'Letter already guessed, please guess a new letter: '
        guess = gets.chomp
      end
    end

    guess_letter(guess)
  end

  def game_over?
    right_guesses == hang_word
  end
end
