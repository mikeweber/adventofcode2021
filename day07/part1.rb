class Aligner
  def self.run(input)
    positions = input.split(",").map(&:to_i)
    aligner = new(positions)
    starting_pos = positions.sum / positions.size
    attempts = positions.max
    min_fuel = nil
    best_pos = nil
    attempts.times do |i|
      delta = i % 2 == 0 ? i / 2 : -(i / 2.0).ceil.to_i
      test_pos = starting_pos + delta
      fuel_cost = aligner.assess_increasing_cost(test_pos)
      if min_fuel.nil? || fuel_cost < min_fuel
        min_fuel = fuel_cost
        best_pos = test_pos
      end
    end
    return [best_pos, min_fuel]
  end

  attr_reader :positions

  def initialize(positions)
    @positions = positions
  end

  def assess_linear_cost(starting_position)
    positions.each.inject(0) do |cost, i|
      cost + (starting_position - i).abs
    end
  end

  def assess_increasing_cost(starting_position)
    positions.each.inject(0) do |cost, i|
      cost + movement_cost((starting_position - i).abs)
    end
  end

  def movement_cost(dist)
    half = dist / 2.0
    extra = 0
    unless half % 1 == 0
      extra = half.ceil
    end
    (dist + 1) * half.floor + extra
  end
end

if ARGV.length == 1
  position, cost = Aligner.run(File.open(ARGV[0]).read)
  puts "The most efficient position is #{position} and the fuel cost is #{cost}"
end

# guess 48399000 is too low
