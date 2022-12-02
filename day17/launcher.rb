class Launcher
  attr_reader :x_range, :y_range
  attr_accessor :pos_x, :pos_y, :vel_x, :vel_y, :max_height

  def self.init(input)
    coords = input.split("x=")[1]
    x, y = coords.split(", y=")
    new(eval(x), eval(y))
  end

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
  end

  def search
    search_max_height = 0
    (13..15).each do |x|
      (1..156).to_a.reverse.each do |y|
        fire_at(x, y)
        result = nil
        while result.nil?
          result = step
        end

        # if result
        #   puts "Firing at #{x}, #{y}"
        #   puts "Hit target"
        # end
        if result && max_height > search_max_height
          puts "new max height"
          search_max_height = max_height
        end
      end
    end
    search_max_height
  end

  def fire_at(vel_x, vel_y)
    self.pos_x = 0
    self.pos_y = 0
    self.vel_x = vel_x
    self.vel_y = vel_y
    self.max_height = 0
  end

  def step
    self.pos_x += vel_x
    self.pos_y += vel_y
    drag = vel_x > 0 ? -1 : (vel_x < 0 ? 1 : 0)
    self.vel_x += drag
    self.vel_y -= 1
    self.max_height = pos_y if pos_y > max_height

    return false if past_target?
    return true if in_target?
  end

  def past_target?
    pos_x > x_range.max || pos_y < y_range.min
  end

  def in_target?
    x_range.include?(pos_x) && y_range.include?(pos_y)
  end
end
