require './code_peg.rb'

class Code

  attr_reader :pegs

  def self.random
    pegs = Array.new(4).map { CodePeg.random }
    pegs
  end

  def self.parse(input)
    pegs = []
    input.each_char { |char| pegs << CodePeg.from_char(char) }
    Code.new(pegs)
  end


  def initialize(pegs = Code.random)
    @pegs = pegs
  end


  def display
    colors = ''
    @pegs.each do |peg|
      colors << peg.display
    end
    colors
  end

end
