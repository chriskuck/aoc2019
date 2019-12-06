# probably a directed acyclical graph
class Graph
  def initialize
    @nodes = { }
  end

  def add_edge(a,b)
    puts "#{a},#{b}"
    add_node(a)
    add_node(b)
    @nodes[a][:child_nodes] << b
    @nodes[b][:parent_nodes] << a
  end

  def add_node(key)
    if @nodes[key] == nil
      @nodes[key] = {}
      @nodes[key][:child_nodes] = []
      @nodes[key][:parent_nodes] = []
    end
  end

  def traverse_length(key)
    sum = 0
    @nodes[key][:parent_nodes].each do |n|
      l = traverse_length(n) + 1
      sum = sum + l
    end
    sum
  end

  def total_traverse_length
    sum = 0
    @nodes.each do |k,v|
      sum = sum + traverse_length(k)
    end
    sum
  end

end

class Parser
  def initialize(filename)
    @contents = File.read(filename)
  end

  def parse

    graph = Graph.new
    @contents.split("\n").each do |l|
      new_edge = l.split(")")
      graph.add_edge(new_edge[0], new_edge[1])
    end
    graph
  end
end
