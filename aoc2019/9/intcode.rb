# frozen_string_literal: true

class Machine

  def initialize(program_text_in)
    @program = program_text_in.split(',').map(&:to_i)
    @halted = false
    @counter = 0
    @in_stream = nil
    @out_stream = nil
    @offset = 0
  end

  def step
    incr = process_op
    @counter += incr
  end

  def process(input, output)
    @waiting = false
    @in_stream = input
    @out_stream = output

    while !@halted && !@waiting && peek_op
      incr = process_op
      @counter += incr
    end

    return 0 if @halted
    return 1 if @waiting
    return 2
  end

  def []=(*args)
    @program[args[0]] = args[1]
  end

  def [](*args)
    @program[args[0]]
  end

  def program_text
    @program.join(",")
  end

  private

  # emergency routines
  def halt
    @halted = true
  end

  def catch_fire(error = nil)
    $stderr.write("ERROR: #{error}")
    throw error
  end

  # translation
  def lookup(mode, val)
    return @program[val] if mode.zero?
    return val if mode == 1
    return @program[val + @offset] if mode == 2
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
    when 9
      return 2
    when 99
      return 1
    else
      catch_fire("op_length: code:#{code}")
    end
  end

  # TODO: should this be a peek or some other type of method to determine all data about an instruction
  def peek_op
    c = @counter
    catch_fire if c > @program.size
    mode_op_code = @program[c]
    code = mode_op_code % 100
    catch_fire if op_length(code) + c > @program.size
    modes = (mode_op_code / 100).to_s.rjust(op_length(code) - 1, '0').chars.reverse.map(&:to_i)
    [code, modes]
  end

  # TODO: validate each instruction before execution
  def process_op
    (opcode, modes) = peek_op
    puts "op: #{opcode}, modes: #{modes.to_s}"
    puts "prg: #{@program.to_s}"
    case opcode

    # ADD: 1, *X, *Y, *(X+Y)
    when 1
      halt if modes[2] != 0
      @program[@program[@counter + 3]] = lookup(modes[0], @program[@counter + 1]) + lookup(modes[1], @program[@counter + 2])
      return 4

    # MULT: 2, *X, *Y, *(X+Y)
    when 2
      halt if modes[2] != 0
      @program[@program[@counter + 3]] = lookup(modes[0], @program[@counter + 1]) * lookup(modes[1], @program[@counter + 2])
      return 4

    # INPUT: 3, ADDR
    when 3
      halt if modes[0] != 0
      input = read_input
      if input.nil?
        @waiting = true
        return 0
      end
      @program[@program[@counter + 1]] = input
      return 2

      # OUTPUT: 4, *ADDR
    when 4
      write_output(lookup(modes[0], @program[@counter + 1]))
      return 2

      # JUMP-IF-TRUE: 5, *BOOL, *INST_PTR
    when 5
      if lookup(modes[0], @program[@counter + 1]) != 0
        @counter = lookup(modes[1], @program[@counter + 2])
        return 0
      else
        return 3
      end

      # JUMP-IF-FALSE: 6, *BOOL, *INST_PTR
    when 6
      if lookup(modes[0], @program[@counter + 1]).zero?
        @counter = lookup(modes[1], @program[@counter + 2])
        return 0
      else
        return 3
      end

      # LESS-THAN: 7, *X, *Y, *(X<Y?1:0)
    when 7
      halt if modes[2] != 0
      value = lookup(modes[0], @program[@counter + 1]) < lookup(modes[1], @program[@counter + 2]) ? 1 : 0
      @program[@program[@counter + 3]] = value
      return 4

      # EQUALS: 8, *X, *Y, *(X=Y?1:0)
    when 8
      halt if modes[2] != 0
      value = lookup(modes[0], @program[@counter + 1]) == lookup(modes[1], @program[@counter + 2]) ? 1 : 0
      @program[@program[@counter + 3]] = value
      return 4

      # UPDATE OFFSET: 9 *OFFSET
    when 9
      @offset = lookup(modes[0], @program[@counter+1])
      return 2

      # HALT: 99
    when 99
      halt
      return 1

    else
      catch_fire("opcode: #{opcode}")
    end
  end

  # I/O routines
  def read_input
    return nil if @in_stream.eof?

    fetch_word
  end

  def fetch_word
    val = ''
    c = @in_stream.getc
    while c != ',' && c != '\n' && !c.nil?
      val = val + c
      c = @in_stream.getc
    end
    val.to_i
  end

  def write_output(value)
    @out_stream.write("#{value},")
  end
end

