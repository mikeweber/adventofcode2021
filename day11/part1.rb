require "set"
require_relative "../day09/grid"

class Cave
  private

  attr_reader :cave

  public

  def self.init(input)
    new(input.split("\n").map { |row| row.split("").map(&:to_i) })
  end

  def initialize(matrix)
    @cave = Grid.new(matrix)
  end

  def run(steps)
    steps.times.inject(0) do |sum, _|
      sum + step
    end
  end

  def find_full_flash
    steps = 1
    while step < 100
      steps += 1
    end
    steps
  end

  def step
    flashes = FlashTracker.new

    cave.each do |oct, pos|
      step_at(pos, flashes)
    end
    flashes.each do |pos|
      cave[pos] = 0
    end
    flashes.size
  end

  def step_at(pos, flashes)
    return if cave[pos].nil?

    cave[pos] += 1
    if cave[pos] > 9 && flashes << pos
      flash(pos, flashes)
    end
  end

  def flash(pos, flashes)
    step_at(pos.north, flashes)
    step_at(pos.northeast, flashes)
    step_at(pos.east, flashes)
    step_at(pos.southeast, flashes)
    step_at(pos.south, flashes)
    step_at(pos.southwest, flashes)
    step_at(pos.west, flashes)
    step_at(pos.northwest, flashes)
  end
end

class FlashTracker
  def initialize
    @flashes = Set.new
  end

  def <<(pos)
    return false if @flashes.include?(pos)

    @flashes << pos
    true
  end

  def each(&block)
    return enum_for(:each) unless block_given?

    @flashes.each(&block)
  end

  def size
    @flashes.size
  end
end

if ARGV.length == 1
  result = Cave.init(File.open(ARGV[0]).read).find_full_flash
  puts "Everyone flashed after #{result} steps"
end
# 275 too low

if ARGV.length == 2
  result = Cave.init(File.open(ARGV[0]).read).run(ARGV[1].to_i)
  puts "There have been #{result} flashes after #{ARGV[1]} steps"
end
