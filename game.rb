require './code.rb'
require 'byebug'

class Game

  def initialize(code = Code.new, turns = [])
    @code = code
    @turns = turns
  end

  def play
    until over?
      take_turn
      puts "#{10 - @turns.count} turns left!"
    end

    if @turns.count == 10
      puts "No more turns left!  Game over!"
    elsif won?
      puts "You won!  Thanks for playing!"
    end
    puts "The correct computer code was #{@code.display}."
  end

  def over?
    won? || @turns.count == 10
  end

  def take_turn
    input = get_input
    user_code = Code.parse(input)
    puts display(evaluate_guess(user_code))
    @turns << user_code
  end

  def display(guess_result)
    black_pegs = guess_result.count do |guess|
      guess.nil? ? false : guess[0] == :black
    end
    white_pegs = guess_result.count do |guess|
      guess.nil? ? false : guess[0] == :white
    end
    "black pegs: #{black_pegs}\nwhite pegs:#{white_pegs}"
  end

  def previous_turns
  end

  #TODO check for invalid input
  def get_input
    input = ''
    loop do
      puts "What is your guess?"
      input = gets.chomp
      break if valid_input?(input)
    end
    input
  end

  def valid_input?(input)
    if input.size != 4
      puts "Invalid input!"
      return false
    end

    input.each_char do |char|
      if !CodePeg::PEG_COLORS.include?(CodePeg.char_to_color(char))
        puts "Invalid input!"
        return false
      end
    end
    true
  end

  def won?
    if @turns.any?
      @turns.last.pegs == @code.pegs
    else
      false
    end
  end

  def evaluate_guess(user_code)
    key_pegs = Array.new(4)
    black_pegs(key_pegs, user_code)
    white_pegs(key_pegs, user_code)
    key_pegs
  end

  def black_pegs(key_pegs, user_code)
    @code.pegs.each_with_index do |peg1, index1|
      user_code.pegs.each_with_index do |peg2, index2|
        if peg1 == peg2 && index1 == index2
          key_pegs[index1] = [:black, [peg1.color, index1]]
        end
      end
    end
    key_pegs
  end

  def white_pegs(key_pegs, user_code)
    key_pegs.each_with_index do |key_peg, index|
      if !key_peg.nil? && key_peg[0] == :black
        next
      end
      current_peg = user_code.pegs[index]
      @code.pegs.each_with_index do |peg, index2|
        if peg == current_peg &&
          does_not_exist(current_peg.color, index2, key_pegs)
          key_pegs[index] = [:white, [current_peg.color, index2]]
        end
      end
    end
    key_pegs
  end

  def does_not_exist(color, index, pegs_array)
    pegs_array.each do |peg|
      next if peg.nil?
      if existing_matches(pegs_array).include?([color, index])
        return false
      end
    end
    true
  end

  def existing_matches(pegs_array)
    pegs_array.map do |peg|
      if peg.nil?
        nil
      else
        peg[1]
      end
    end
  end
end
