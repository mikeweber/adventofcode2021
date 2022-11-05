class CaveTraverser
  attr_reader :graph

  def self.init(input)
    input.split("\n").map { |line| line.split("-") }
  end

  def initialize(edges)
    @graph = Graph.new(edges)
  end

  def run
    traverse(graph.start)
  end


  def traverse(node, visited = Set.new, one_time_visits = Set.new)
    puts "traversing #{node.name}"
    if node == graph.finish
      puts "at end"
      visited << node
      one_time_visits << node if node.small?
      return ["end"]
    end
    return [] if one_time_visits.include?(node)

    neighbors = graph.neighbors(node) - visited
    puts "neighbors of #{node}: #{neighbors.inspect}"
    visited << node
    one_time_visits << node if node.small?

    paths = neighbors.each.inject(Set.new) do |paths, neighbor|
      paths << node.name unless node == graph.finish

      neighboring_paths = traverse(neighbor, visited, one_time_visits)
      puts "paths: #{paths}"
      puts "neighboring_paths from #{neighbor}: #{neighboring_paths}"
      new_paths = paths.reject { |path| path.split(",")[-1] == "end" }.each.with_object([]) do |local_path, new_paths|
        neighboring_paths.each do |neighboring_path|
          if neighboring_path.split(",")[-1] == "end"
            puts "Adding path: #{local_path},#{neighboring_path}"
            new_paths << "#{local_path},#{neighboring_path}"
          end
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
