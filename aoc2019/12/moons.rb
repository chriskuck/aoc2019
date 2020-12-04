require './moon'

class Moons
  attr_reader :moons

  def initialize(positions)
    positions = parse_positions(positions)

    #make the moons
    @moons = positions.map { |moon_pos| Moon.new(moon_pos) }
  end

  def step
    @moons.combination(2).each do |m1, m2|
      velocities = gravity(m1, m2)
      m1.alter_velocity(velocities[0])
      m2.alter_velocity(velocities[1])
    end
    @moons.each(&:move)
  end

  def report
    (0..@moons.size-1).each do |i|
      puts "#{i} - <#{@moons[i].pretty_position(3)}>, <#{@moons[i].pretty_velocity(3)}> "
    end
    puts "ENERGY: #{energy}"
  end

  def axis_positions
    res = [[],[],[]]
    for i in (0..2) do
      for moon in @moons do
        res[i] << moon.position[i]
      end
    end
    res
  end
  private

  def parse_positions(positions)
    # parse the positions
    moon_positions = positions
      .split("\n")
      .map do |str|
        str
          .match(/<x=([\-0-9]+), y=([\-0-9]+), z=([\-0-9]+)>/)
          .captures
      end

  end

  def gravity(m1, m2)
    delta1 = m1.position.zip(m2.position).map {|pair| [1, [-1, (pair[1]-pair[0])].max].min }
    delta2 = delta1.map {|v| -v}
    [delta1, delta2]
  end

  def energy
    @moons.map(&:energy).sum
  end


end
