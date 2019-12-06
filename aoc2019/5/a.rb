require 'IO/console'

class Program
  def initialize(input)
    @program = input.split(',').map(&:to_i)
    @halted = false
    @counter = 0
  end

  def step
    puts self
    @counter += process_op
  end

  def process
    while !@halted && peek_op do
      @counter += process_op
    end
  end

  private

  def []=(*args)
      @program[args[0]] = args[1]
  end

  def [](*args)
    return @program[args[0]]
  end

  def lookup(mode, val)
    return @program[val] if mode == 0
    return val if mode == 1
  end

  def op_length(code)
    case code
    when 1
      return 4
    when 2
      return 4
    when 3
      return 2
    when 4
      return 2
    when 99
      return 1
    else
      catch_fire("op_length: code:#{code}")
    end
  end

  def halt()
    puts "HALTING"
    @halted = true
  end

  def catch_fire(error=nil)
    puts "ERROR: #{error}"
    exit(1)
  end

  def peek_op
    c = @counter
    catch_fire() if c > @program.size
    mode_op_code = @program[c]
    code = mode_op_code % 100
    catch_fire() if op_length(code) + c > @program.size
    modes = (mode_op_code / 100).to_s.rjust(op_length(code)-1,'0').chars.reverse.map(&:to_i)
    return [code, modes]
  end

  def process_op
    (opcode, modes) = peek_op
    case opcode
      when 1
        halt() if modes[2] != 0
        @program[@program[@counter+3]] = lookup(modes[0], @program[@counter+1]) + lookup(modes[1], @program[@counter+2])
        return 4
      when 2
        halt() if modes[2] != 0
        @program[@program[@counter+3]] = lookup(modes[0], @program[@counter+1]) * lookup(modes[1], @program[@counter+2])
        return 4
      when 3
        halt() if modes[0] != 0
        @program[@program[@counter+1]] = (STDIN.getch).to_i
        return 2
      when 4
        puts "#{@counter}:#{lookup(modes[0], @program[@counter+1])}"
        return 2
      when 99
        halt()
        return 1
      else
        puts "error opcode: #{opcode}"
      end
  end
end

def read_program(filename)
  File.read(filename)
end

