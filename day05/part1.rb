class VentMap
  attr_reader :width, :height, :map, :spikes

  def initialize(input)
    @width = 0
    @height = 0
    @map = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = 0 } }
    @spikes = 0

    input.split("\n").each do |line|
      one, two = line.split(" -> ")
      x1, y1 = one.split(",").map(&:to_i)
      x2, y2 = two.split(",").map(&:to_i)
      if x1 > width || x2 > width
        @width = [x1, x2].max
      end
      if y1 > height || y2 > height
        @height = [y1, y2].max
      end
      if x1 == x2
        y1, y2 = [y1, y2].sort
        (y1..y2).each do |y|
          map[x1][y] += 1
          if map[x1][y] == 2
            @spikes += 1
          end
        end
      elsif y1 == y2
        x1, x2 = [x1, x2].sort
        (x1..x2).each do |x|
          map[x][y1] += 1
          if map[x][y1] == 2
            @spikes += 1
          end
        end
      else
        deltax = x1 < x2 ? 1 : -1
        deltay = y1 < y2 ? 1 : -1
        x = x1 - deltax
        y = y1 - deltay
        while x != x2
          map[x][y] += 1
          if map[x][y] == 2
            @spikes += 1
          end
          x += deltax
          y += deltay
        end
      end
    end
  end

  def draw
    s = ""
    (height + 1).times do |y|
      (width + 1).times do |x|
        p = map[x][y].to_s
        p = "." if p == "0"
        s << p
      end
      s << "\n"
    end
    s
  end
end

if ARGV.length == 1
  map = VentMap.new(File.open(ARGV[0]).read)
  puts "There are #{map.spikes} spikes"
end
