# frozen_string_literal: true

require_relative '../lib/prelude'

HEIGHT_MAP = ('a'..'z').to_a

def to_height(char)
  return 25 if char == 'E'
  return 0 if char == 'S'

  HEIGHT_MAP.index(char)
end

class GraphNode
  attr_reader :height, :x, :y, :adjacent

  def initialize(x, y, height)
    @x = x
    @y = y
    @height = height
    @adjacent = Set.new
  end

  def add_adjacent(node)
    @adjacent << node
  end

  def to_s
    "GraphNode(#{x}, #{y}, #{height})"
  end

  def hash
    [x, y].hash
  end

  def eql?(other)
    x == other.x && y == other.y
  end
end

class Graph
  attr_reader :nodes

  def initialize
    @nodes = []
  end

  def add_node(node)
    @nodes[node.y] ||= []
    @nodes[node.y][node.x] = node
  end
end

$graph = Graph.new

start_nodes = Set.new
end_node = nil

$input.each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    height = to_height(char)
    node = GraphNode.new(x, y, height)
    $graph.add_node(node)

    start_nodes << node if height.zero?
    end_node = node if char == 'E'

    unless (y - 1).negative?
      adjacent_node = $graph.nodes[y - 1][x]

      adjacent_node.add_adjacent(node) if adjacent_node.height - node.height <= 1
      node.add_adjacent(adjacent_node) if node.height - adjacent_node.height <= 1
    end

    unless (x - 1).negative?
      adjacent_node = $graph.nodes[y][x - 1]

      adjacent_node.add_adjacent(node) if adjacent_node.height - node.height <= 1
      node.add_adjacent(adjacent_node) if node.height - adjacent_node.height <= 1
    end
  end
end

def shortest_path_length(start_node, end_nodes)
  distances = Hash.new { Float::INFINITY }
  distances[start_node] = 0
  previous = {}
  nodes = Set.new($graph.nodes.flatten)

  return [] if start_node.adjacent.empty?

  until nodes.empty?
    current = nodes.min_by { |node| distances[node] }
    nodes.delete(current)

    current.adjacent.each do |adjacent|
      next if (alt = distances[current] + 1) >= distances[adjacent]

      distances[adjacent] = alt
      previous[adjacent] = current
    end
  end

  end_nodes.each do |end_node|
    puts "Start: #{end_node.x}, #{end_node.y}, #{end_node.height}"

    current = end_node
    length = 0
    while current
      puts "  Next: #{current.x}, #{current.y}, #{current.height}"
      current = previous[current]
      length += 1
    end
    puts "  Steps: #{length - 1}"
  end

  end_nodes.map { |end_node| distances[end_node] }
end

puts "Start nodes length: #{start_nodes.size}"

path_lengths = shortest_path_length(end_node, start_nodes)
min_length = path_lengths.min
puts(min_length)
