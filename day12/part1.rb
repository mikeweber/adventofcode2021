require "set"

class CaveTraverser
  attr_reader :graph, :small_cave_limit

  def self.init(input)
    new(input.split("\n").map { |line| line.split("-") })
  end

  def initialize(edges)
    @graph = Graph.new(edges)
  end

  def run(small_cave_limit = 1)
    @small_cave_limit = small_cave_limit
    limited_visits = Hash.new { |h, k| h[k] = 0 }
    limited_visits[graph.start] = small_cave_limit - 1
    limited_visits[graph.finish] = small_cave_limit - 1
    traverse(graph.start, limited_visits)
  end

  private

  def traverse(node, limited_visits, visited = Hash.new { |h, k| h[k] = 0 })
    if node == graph.finish
      visited[node] += 1
      limited_visits[node] += 1
      return ["end"]
    end
    return [] if limited_visits[node] >= small_cave_limit

    neighbors = graph.neighbors(node) - visited.select { |_, k| k == small_cave_limit }.keys
    visited[node] += 1
    limited_visits[node] += 1 if node.small?

    paths = neighbors.each.inject(Set.new) do |paths, neighbor|
      paths << node.name unless node == graph.finish

      neighboring_paths = traverse(neighbor, limited_visits.dup, visited.dup)
      new_paths = paths.reject { |path| path.split(",")[-1] == "end" }.each.with_object([]) do |local_path, new_paths|
        neighboring_paths.each do |neighboring_path|
          new_paths << "#{local_path},#{neighboring_path}"
        end
      end
      paths + new_paths
    end.select { |path| path.split(",")[-1] == "end" }
  end
end

class Graph
  private

  attr_reader :nodes, :edges

  public

  attr_reader :start, :finish

  def initialize(raw_edges)
    @nodes = Set.new
    @edges = Hash.new { |h, k| h[k] = Set.new }
    build_graph(raw_edges)
  end

  def build_graph(raw_edges)
    @start = Node.new("start")
    @finish = Node.new("end")
    nodes << @start
    nodes << @end
    raw_edges.each do |x, y|
      x_node = Node.new(x)
      y_node = Node.new(y)
      nodes << x_node
      nodes << y_node
      edges[x_node] << y_node
      edges[y_node] << x_node
    end
  end

  def neighbors(node)
    edges[node]
  end
end

class Node
  attr_reader :name

  def initialize(name)
    @name = name
    @small = 97 <= name.ord && name.ord <= 122
  end

  def eql?(other)
    self == other
  end

  def ==(other)
    name == other.name
  end

  def hash
    name.hash
  end

  def small?
    @small
  end

  def to_s
    inspect
  end

  def inspect
    "<Node:#{name}>"
  end
end

# if ARGV.length == 1
#   result = CaveTraverser.init(File.open(ARGV[0]).read).run.size
#   puts "result: #{result}"
# end
