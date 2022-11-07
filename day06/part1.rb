class Fish
  private
  attr_writer :timer

  public

  attr_reader :timer

  def initialize(timer = 8)
    self.timer = timer
  end

  def step
    if timer == 0
      self.timer = 6
      return Fish.new
    end
    self.timer -= 1
    nil
  end
end

class FishTank
  attr_reader :tank

  def initialize(input)
    @tank = input.split(",").map { |timer| Fish.new(timer.to_i) }
  end

  def run(days)
    puts "running for #{days} days"
    day_map = Hash.new { |h, k| h[k] = [] }
    day_sizes = []
    day_diffs = []
    days.times do |day|
      day_sizes << tank.size
      new_fish = tank.map { |fish| fish.step }.compact
      @tank += new_fish
      day_map[day % 7] << tank.size
      day_diffs << new_fish.size
      # puts "actual new:    #{new_fish.size}"
      # if day > 7
      #   prediction = 2 ** day_map[day % 7].each.inject(0) { |sum, fish| sum + (fish.timer == 6 ? 1 : 0) }
      #   puts "predicted new: #{predicition}"
      # end
    end
    7.times do |i|
      puts day_sizes.map.with_index { |x, j| x if j % 7 == i }.compact.inspect
    end
    puts "-----"
    7.times do |i|
      puts day_diffs.map.with_index { |x, j| x if j % 7 == i }.compact.inspect
    end
    tank.size
  end
end

class FishTank2
  attr_reader :tank
  def initialize(input)
    @tank = input.split(",").map(&:to_i)
  end

  def run(days)
    week = []
    next_spawners = 0
    next_pending_spawners = [0, 0, 0]
    current_population = tank.size
    7.times do |day|
      week[day] = {
        spawners: next_spawners,
        pending_spawners: next_pending_spawners.shift
      }
      # puts "day #{day} (#{current_population}): #{week[day % 7].inspect} -- #{tank.join(",")}"
      next_spawners = tank.select { |x| x == 0 }.size
      step_tank!
      current_population = tank.size
      week[day][:spawners] += week[day][:pending_spawners]
      next_pending_spawners << tank.select { |x| x == 8 }.size
    end
    week[0][:spawners] = next_spawners
    next_pending_spawners.each.with_index do |pending, i|
      week[i][:pending_spawners] = pending
    end

    (days - 6).times do |day|
      puts "Week #{day / 7 + 1}" if day % 7 == 0
      spawned = week[day % 7][:spawners]
      current_population += spawned
      week[(day + 2) % 7][:pending_spawners] = spawned
      week[day % 7][:spawners] += week[day % 7][:pending_spawners]
      # puts "day #{day + 7} (#{current_population}): #{week[day % 7].inspect} -- #{tank.join(",")}"
      # step_tank!
    end
    current_population
  end

  def step_tank!
    new_tank = []
    @tank = tank.map do |x|
      x -= 1
      if x == -1
        x = 6
        new_tank << 8
      end
      x
    end
    @tank += new_tank
  end
end

if ARGV.length == 2
  result = FishTank2.new(File.open(ARGV[0]).read).run(ARGV[1].to_i)
  puts "There are #{result} fish in the tank after #{ARGV[1]} days"
end
