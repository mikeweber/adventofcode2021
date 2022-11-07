require_relative "./grid"

class LavaTubeScanner
  attr_reader :heights

  def self.run(input)
    lines = input.split("\n")
    new(lines.map { |x| x.split("").map(&:to_i) }).scan
  end

  def initialize(matrix)
    @heights = Grid.new(matrix)
  end

  def scan
    risk_level = 0
    heights.each do |height, x, y|
      is_low_point = true
      if 0 < y
        is_low_point = height < heights.at(x, y - 1)
      end
      if is_low_point && y < heights.height - 1
        is_low_point = height < heights.at(x, y + 1)
      end
      if is_low_point && 0 < x
        is_low_point = height < heights.at(x - 1, y)
      end
      if is_low_point && x < heights.width - 1
        is_low_point = height < heights.at(x + 1, y)
      end
      if is_low_point
        risk_level += 1 + height
      end
    end
    risk_level
  end
end

if ARGV.length == 1
  input = File.open(ARGV[0]).read
  result = LavaTubeScanner.run(input)
  puts "Risk score is #{result}"
end
