class Paper
  attr_reader :grid, :folds

  def self.init(input)
    lines = input.split("\n")
    folds = []
    while (line = lines.pop) != ""
      axis, coord = line.split(" ")[-1].split("=")
      folds << [axis, coord.to_i]
    end

    positions = lines.map do |line|
      x, y = lines[0].split(",").map(&:to_i)
      Position.new(x, y)
    end
    new(positions, folds)
  end

  def initialize(positions, folds)
    @folds = folds
    @grid = Grid.new
    positions.each do |pos|
      puts pos.inspect
      grid[pos] = "#"
    end
  end

  def fold!
    axis, fold = folds.pop
    new_grid = Grid.new
    if axis == "x"
      grid.height.times do |y|
        (fold..grid.width).each do |x|
          src_pos = Position.new(x, y)
          dest_pos = Position.new(fold - x, y)
          new_grid[dest_pos] = grid[dest_pos] || grid[src_pos]
        end
      end
    else
      grid.width.times do |x|
        (fold..(grid.height)).each do |y|
          src_pos = Position.new(x, y)
          dest_pos = Position.new(x, fold - y)
          new_grid[dest_pos] = grid[dest_pos] || grid[src_pos]
        end
      end
    end
    @grid = new_grid
    self
  end

  def to_s
    inspect
  end

  def inspect
    grid.inspect
  end
end

class Grid
  attr_reader :width, :height, :rows

  def initialize
    @width = 0
    @height = 0
    @rows = Hash.new { |h, k| h[k] = [] }
  end

  def []=(pos, val)
    @width = pos.x + 1 if pos.x >= width
    @height = pos.y + 1 if pos.y >= height
    rows[pos.y][pos.x] = val
  end

  def inspect
    s = ""
    height.times do |y|
      width.times do |x|
        s << (rows[y][x] || ".")
      end
      s << "\n"
    end
    s
  end

  def [](pos)
    rows[pos.y][pos.x]
  end
end

class Position
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    inspect
  end

  def inspect
    "<Pos x:#{x} y:#{y}>"
  end

  def eql?(other)
    self == other
  end

  def hash
    "#{x},#{y}".hash
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def north
    self.class.new(x, y - 1)
  end

  def northeast
    self.class.new(x + 1, y - 1)
  end

  def east
    self.class.new(x + 1, y)
  end

  def southeast
    self.class.new(x + 1, y + 1)
  end

  def south
    self.class.new(x, y + 1)
  end

  def southwest
    self.class.new(x - 1, y + 1)
  end

  def west
    self.class.new(x - 1, y)
  end

  def northwest
    self.class.new(x - 1, y - 1)
  end
end

if ARGV.length == 1
  paper = Paper.init(File.open(ARGV[0]).read)
  puts paper.inspect
  puts "fold!"
  puts paper.fold!.inspect
end
