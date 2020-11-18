class Robot

  def initialize(machine)

    @machine = machine
    @facing = 0
    @coords = [0,0]

  end

  def go(world)

    code = 1
    while code != 0
      color = world.sense(@coords)
      input = StringIO.new("#{color},")
      output = StringIO.new
      code = @machine.process(input,output)
      commands = output.string.split(',')
      world.paint(commands[0].to_i, @coords.map(&:clone))
      turn(commands[1].to_i)
      move_forward
    end

  end

  def move_forward
    case @facing
    when 0
      @coords[1] += 1
    when 1
      @coords[0] += 1
    when 2
      @coords[1] -= 1
    when 3
      @coords[0] -= 1
    end
  end

  def turn(direction)
    if direction == 0
      turn_left
    elsif direction == 1
      turn_right
    end
  end

  def turn_left
    @facing -= 1
    @facing += 4 if @facing < 0
    @facing %= 4
  end

  def turn_right
    @facing += 1
    @facing += 4 if @facing < 0
    @facing %= 4
  end

    
end
