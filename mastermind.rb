class Code
  attr_reader :pegs
  
  PEGS = { :red => "R",
           :green => "G",
           :blue => "B",
           :yellow => "Y",
           :orange => "O",
           :purple => "P"
  }
  
  def self.parse(pegs)
    pegs.upcase.chars.each do |peg| 
      (raise "invalid color pegs") if !PEGS.values.include?(peg) 
    end
    
    Code.new(pegs.upcase.chars)
  end 
 
  def self.random
    Code.new(PEGS.values.sample(4))
  end 
  
  def initialize(pegs)
    @pegs = pegs 
  end 
  
  def [](index)
    pegs[index]
  end 
  
  def exact_matches(other_code)
    (0...pegs.length).reduce(0) do |count, idx| 
      pegs[idx] == other_code.pegs[idx] ? count + 1 : count 
    end 
  end 
  
  def near_matches(other_code)
    count = 0
    exact_matches = exact_matches_index(other_code)
    
    pegs.each_with_index do |peg, idx|
      matched = other_code.pegs.index(peg)
      if matched != nil && !exact_matches.include?(idx) && !exact_matches.include?(matched)
        count += 1
        other_code.pegs[matched] = "-"
      end 
    end 
    
    count
  end 
  
  def ==(other_code)
    return false if !other_code.is_a?(Code)
    pegs == other_code.pegs 
  end 
  
  private
  def exact_matches_index(other_code)
    (0...pegs.length).select { |idx| pegs[idx] == other_code.pegs[idx] }
  end 
end

class Game
  attr_reader :secret_code
  
  def initialize(code = nil)
    code ||= Code.random
    @secret_code = code 
  end 
  
  def get_guess
    puts "Guess a code"
    
    begin
      Code.parse(gets.chomp)
    rescue 
      puts "Error, Guess a code again"
      retry 
    end 
  end 
  
  def display_matches(code)
    puts "You have #{secret_code.exact_matches(code)} exact matches and #{secret_code.near_matches(code)} near matches"
  end 
  
  def play 
    10.times do |i|
      puts "Turn #{i + 1}"
      guessed_code = get_guess
      display_matches(guessed_code)
      
      if won?(guessed_code) 
        puts "You won, the secret code is #{secret_code.pegs.join("")}"
        break
      end 
      puts "You lose!, you have used up the 10 turns" if i == 9
    end 
  end 
  
  private 
  def won?(code)
    secret_code.exact_matches(code) == 4
  end 
end

if __FILE__ == $PROGRAM_NAME
  code = Code.parse("BYGR")
  Game.new(code).play
  #Game.new.play
end 