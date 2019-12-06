
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

real_sum = 0
l = Logic.new
read_all_stdin do |i|
  total_mass = 0
  total_fuel_mass = i.to_i
  loop do
    newl = Logic.new
    newl.process(total_fuel_mass)

    total_mass = total_mass + [0, newl.sum].max
    total_fuel_mass = [0, newl.sum].max

    break if newl.sum <= 0
  end
  real_sum = real_sum + total_mass
end

puts real_sum
