class Grid
  include Enumerable

  private

  attr_reader :matrix

  public

  attr_reader :width, :height

  def initialize(matrix)
    @matrix = matrix
    @width = matrix[0].size
    @height = matrix.size
  end

  def [](pos)
    return unless valid_position?(pos)

    matrix[pos.y][pos.x]
  end

  def []=(pos, value)
    return unless valid_position?(pos)

    matrix[pos.y][pos.x] = value
  end

  def orthogonal_neighbors_to(pos)
    [pos.north, pos.south, pos.east, pos.west].select { |x| valid_position?(x) }
  end

  def each
    return enum_for(:each) unless block_given?

    matrix.each.with_index do |row, y|
      row.each.with_index do |element, x|
        yield element, Position.new(x, y)
      end
    end
  end

  def valid_position?(pos)
    0 <= pos.x && pos.x < width && 0 <= pos.y && pos.y < height
  end

  def inspect
    each.with_object("") do |(el, pos), s|
      s << el.to_s
      s << "\n" if pos.x + 1 == width
    end
  end
end

class Position
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
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
