require_relative "./grid"
require "set"

class LavaTubeScanner
  attr_reader :heights

  def self.run(input)
    lines = input.split("\n")
    new(lines.map { |x| x.split("").map(&:to_i) }).scan
  end

  def initialize(matrix)
    @heights = Grid.new(matrix)
    @debug_grid = Grid.new(matrix.map { |row| row.map { |el| el == 9 ? "#" : el.to_s } })
  end

  def scan
    bucket = BasinBucket.new
    scanned = Set.new
    heights.each do |element, x, y|
      pos = Position.new(x, y)
      next if scanned.include?(pos)

      basin_positions = walk(pos)
      basin_positions.each do |pos1|
        @debug_grid[pos1] = "."
      end
      new_size = basin_positions.size
      bucket << new_size
      scanned += basin_positions
    end
    puts
    line = ""
    @debug_grid.each do |element, x, y|
      line << element.to_s
      if x + 1 == @debug_grid.width
        puts line
        line = ""
      end
    end
    puts
    puts bucket.inspect
    bucket.score
  end

  def walk(pos, visited = Set.new)
    return [] if visited.include?(pos)

    visited << pos
    height = heights[pos]
    if height.nil? || height == 9
      return []
    end

    positions = [pos]
    positions += walk(pos.north, visited)
    positions += walk(pos.south, visited)
    positions += walk(pos.east, visited)
    positions += walk(pos.west, visited)

    positions
  end
end

class BasinBucket
  private

  attr_reader :sizes

  public

  def initialize
    @sizes = []
  end

  def <<(new_size)
    return false if sizes.size == 3 && sizes[2] >= new_size

    sizes << new_size
    sizes.sort!
    sizes.reverse!
    sizes.slice!(3)
    true
  end

  def score
    sizes.inject(:*)
  end

  def inspect
    sizes.inspect
  end
end

if ARGV.length == 1
  input = File.open(ARGV[0]).read
  result = LavaTubeScanner.run(input)
  puts "Largest basin sizes multiplied together is #{result}"
end
# guessed 874000, too low
