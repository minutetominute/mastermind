class CodePeg

  attr_reader :color

  PEG_COLORS = [:red, :green, :blue,
                :yellow, :orange, :purple]

  def self.random
    CodePeg.new(CodePeg.random_color)
  end

  def random
    CodePeg.new(CodePeg.random_color)
  end

  def self.from_char(char)
    CodePeg.new(char_to_color(char))
  end

  def self.char_to_color(char)
    chars_to_color = { 'R' => :red, 'G' => :green, 'B' => :blue,
      'Y' => :yellow, 'O' => :orange, 'P' => :purple}
    chars_to_color[char]
  end

  def self.random_color
    PEG_COLORS.sample
  end

  def initialize(color)
    @color = color
  end

  def ==(code_peg)
    self.color == code_peg.color
  end

  def display
    color.to_s[0].upcase
  end

end
