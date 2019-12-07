require 'IO/console'

class Program
  def initialize(program, in_stream = nil, out_stream = nil)
    @program = program
    @halted = false
    @counter = 0
    @in_stream = in_stream || $stdin
    @out_stream = out_stream || $stdout
  end

  def step
    self.inspect
    incr = process_op
    @counter += incr
  end

  def process
    while !@halted && peek_op do
      incr = process_op
      @counter += incr
    end
  end

  def []=(*args)
      @program[args[0]] = args[1]
  end

  def [](*args)
    return @program[args[0]]
  end

  private


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
    when 5
      return 3
    when 6
      return 3
    when 7
      return 4
    when 8
      return 4
    when 99
      return 1
    else
      catch_fire("op_length: code:#{code}")
    end
  end

  def halt()
    puts "HALTING"
    @in_stream.close()
    @out_stream.close()
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
        @program[@program[@counter+1]] = read_input()
        return 2
      when 4
        write_output(lookup(modes[0], @program[@counter+1]))
        return 2
      when 5
        if lookup(modes[0], @program[@counter+1]) != 0
          @counter = lookup(modes[1], @program[@counter+2])
          return 0
        else
          return 3
        end
      when 6
        if lookup(modes[0], @program[@counter+1]) == 0
          @counter = lookup(modes[1], @program[@counter+2])
          return 0
        else
          return 3
        end
      when 7
        halt() if modes[2] != 0
        value = lookup(modes[0], @program[@counter+1]) < lookup(modes[1], @program[@counter+2]) ? 1 : 0
        @program[@program[@counter+3]] = value
        return 4
      when 8
        halt() if modes[2] != 0
        value = lookup(modes[0], @program[@counter+1]) == lookup(modes[1], @program[@counter+2]) ? 1 : 0
        @program[@program[@counter+3]] = value
        return 4
      when 99
        halt()
        return 1
      else
        puts "error opcode: #{opcode}"
      end
  end

  def read_input(value)
    val = ""
    while
      c = in_stream.getc
      break if c == ',' || c == '\n'
      val << c
    end
    return val.to_i
  end

  def write_output(value)
    out_stream.write("#{value},")
  end
end

def read_program(filename)
  File.read(filename).split(',').map(&:to_i)
end
