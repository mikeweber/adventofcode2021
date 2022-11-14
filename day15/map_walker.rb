require "set"
require_relative "../day09/grid"

class MapWalker
  attr_reader :grid, :start, :goal, :g, :h, :connections

  def initialize(grid)
    @grid = grid
    @start = Position.new(0, 0)
    @goal = Position.new(grid.width - 1, grid.height - 1)
    @open_set = Set.new([@start])
    @closed_set = Set.new
    @g = { start => 0 }
    @h = { start => 0 }
    @connections = {}
  end

  # Source: https://www.rubydoc.info/gems/gastar/AStar
  def walk
    openset = Set.new
    closedset = Set.new
    current = start

    openset_min_max = openset.method(:min_by)

    openset.add(current)
    while not openset.empty?
      current = openset.min_by { |o| g[o] + h[o] }
      if current == goal
        path = []
        while connections[current]
          path << current
          current = connections[current]
        end
        path << current
        return path.reverse
      end
      openset.delete(current)
      closedset.add(current)
      grid.orthogonal_neighbors_to(current).each do |node|
        next if closedset.include? node

        if openset.include? node
          new_g = g[current] + move_cost(current, node)
          if g[node] > new_g
            g[node] = new_g
            connections[node] = current
          end
        else
          g[node] = g[current] + move_cost(current, node)
          h[node] = heuristic(node, start, goal)
          connections[node] = current
          openset.add(node)
        end
      end
    end
    return nil
  end

  private

  attr_reader :open_set, :closed_set, :distance_to_dest, :cost_from_start

  def move_cost(start, dest)
    grid[dest]
  end

  def heuristic(pos, start, goal)
    g[pos] + distance(pos, goal)
  end

  def distance(pos, dest)
    (pos.x - dest.x).abs + (pos.y - dest.y).abs
  end
end
