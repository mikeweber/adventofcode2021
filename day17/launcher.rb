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
    count = 0
    (1..x_range.max).each do |x|
      (y_range.min..900).to_a.reverse.each do |y|
        fire_at(x, y)
        result = nil
        while result.nil?
          result = step
        end

        count += 1 if result
      end
    end
    count
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
