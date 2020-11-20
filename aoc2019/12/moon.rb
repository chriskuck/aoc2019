class Moon

  attr_reader :position

  def initialize(moon_pos)
    @position = moon_pos.map {|p| p.to_i }
    @velocity = [0,0,0]
  end

  def alter_velocity(delta)
    (0..2).each {|i| @velocity[i] += delta[i] }
  end

  def move
    (0..2).each {|i| @position[i] += @velocity[i] }
  end

  def pretty_position(chars)
    ["x", "y", "z"].zip(@position.map {|pos| pos.to_s.rjust(chars, " ")}).map {|pair| pair.join("=") }.join(",")
  end

  def pretty_velocity(chars)
    ["x", "y", "z"].zip(@velocity.map {|pos| pos.to_s.rjust(chars, " ")}).map {|pair| pair.join("=") }.join(",")
  end

  def energy
    @position.map(&:abs).sum * @velocity.map(&:abs).sum
  end
end
