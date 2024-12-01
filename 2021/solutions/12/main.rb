require_relative "../../utils.rb"

class Graph
  class Node
    def initialize(point, connection)
      @point = point
      @connections = [connection]
      @small = point == point.downcase
    end

    attr_reader :point, :connections, :small

    def add_connection!(connection)
      @connections << connection
      @connections.uniq!
    end
  end

  def initialize(nodelist)
    @nodelist = generate_nodes(nodelist)
  end

  def generate_nodes(nodelist)
    nodes = []

    nodelist.each do |node_attributes|
      [node_attributes, node_attributes.reverse].each do |pair|
        point, connection = pair

        existing_node = nodes.detect { |node| node.point == point }

        if existing_node
          existing_node.add_connection!(connection)
        else
          nodes << Node.new(point, connection)
        end
      end
    end

    nodes
  end

  def count_paths(max_small_visit: 1)
    node_start = find_node("start")
    node_end = find_node("end")
    paths = [[node_start]]
    ended_paths = []

    loop do
      new_paths = []

      paths.each do |path|
        node = path.last
        next if node == node_end

        node.connections.each do |connection|
          connected_node = find_node(connection)
          new_paths << (path + [connected_node]) unless connected_node == node_start || exceeded_small_visit_max(path, connected_node, max_small_visit)
        end
      end

      ended_paths += new_paths.select { |path| path.last == node_end }

      break if new_paths.all? { |path| path.last == node_end }

      paths = new_paths - ended_paths
    end

    ended_paths.uniq.count
  end

  def find_node(point)
    @nodelist.detect { |node| node.point == point }
  end

  def exceeded_small_visit_max(path, node, count)
    terminal_nodes = [find_node("start"), find_node("end")]
    small_nodes = path.select { |node| node.small && !terminal_nodes.include?(node) }

    path.count { |target| target.point == node.point } >= count && node.small || \
      small_nodes.count - small_nodes.uniq.count > 1
  end
end

def print_paths(paths)
  paths.each do |path|
    puts path.map { |node| node.point }.join(",")
  end
end

def part_1_solution(strs)
  nodes = strs.map { |str| str.split("-") }

  graph = Graph.new(nodes)

  puts "PART 1: #{graph.count_paths}"
end

def part_2_solution(strs)
  nodes = strs.map { |str| str.split("-") }

  graph = Graph.new(nodes)

  puts "PART 2: #{graph.count_paths(max_small_visit: 2)}"
end

test_strs = %w[
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
]

large_test_strs = %w[
  dc-end
  HN-start
  start-kj
  dc-start
  dc-HN
  LN-dc
  HN-end
  kj-sa
  kj-HN
  kj-dc
]

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt