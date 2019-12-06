
class Logic

  def initialize
    @sum = 0
  end

  def sum
    return @sum
  end

  def process(num)
    @sum = @sum + ((num/3.0).floor-2).to_i
  end

end

def read_all_stdin
  STDIN.read.split("\n").each do |a|
    yield a
  end
end

l = Logic.new
read_all_stdin { |i| l.process(i.to_i) }
puts l.sum
