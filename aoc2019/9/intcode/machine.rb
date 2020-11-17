require_relative 'memory'
require_relative 'address_translation'
# frozen_string_literal: true

class Machine

  def initialize(program_text_in)
    @memory = Memory.new(program_text_in.split(',').map(&:to_i))
    @at = AddressTranslation.new(@memory)

    @halted = false
    @counter = 0
    @in_stream = nil
    @out_stream = nil
  end

  def process(input, output)
    @waiting = false
    @in_stream = input
    @out_stream = output

    while !@halted && !@waiting
      process_op
    end

    return 0 if @halted
    return 1 if @waiting
    return 2
  end

  #  def []=(*args)
  #    @program[args[0]] = args[1]
  #  end
  #
  #  def [](*args)
  #    @program[args[0]]
  #  end

  def program_text
    @memory.contents.join(",")
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



  def fetch_instruction
    mode_op_code = @memory.read(@counter)
    code = mode_op_code % 100
    modes = (mode_op_code / 100).to_s.rjust(op_length(code) - 1, '0').chars.reverse.map(&:to_i)
    [code, modes, @memory.read((@counter+1..@counter+op_length(code)-1).to_a)]
  end

  # TODO: validate each instruction before execution
  def process_op
    # validate_op
    (opcode, modes, addrs) = fetch_instruction


    case opcode

      # ADD: 1, *X, *Y, *(X+Y)
    when 1
      catch_fire if modes[2] == 1
      result = @at.lookup(addrs[0], modes[0]) + @at.lookup(addrs[1], modes[1])
      @at.write(addrs[2], modes[2], result)
      @counter += 4

      # MULT: 2, *X, *Y, *(X+Y)
    when 2
      catch_fire if modes[2] == 1
      result = @at.lookup(addrs[0], modes[0]) * @at.lookup(addrs[1], modes[1])
      @at.write(addrs[2], modes[2], result)
      @counter += 4

      # INPUT: 3, ADDR
    when 3
      catch_fire if modes[0] == 1
      result = read_input
      if result.nil?
        @waiting = true
        return 0
      end
      @at.write(addrs[0], modes[0], result)
      @counter += 2

      # OUTPUT: 4, *ADDR
    when 4
      value = @at.lookup(addrs[0], modes[0])
      write_output(value)
      @counter += 2

      # JUMP-IF-TRUE: 5, *BOOL, *INST_PTR
    when 5
      if @at.lookup(addrs[0], modes[0]) != 0
        @counter = @at.lookup(addrs[1], modes[1])
      else
        @counter += 3
      end

      # JUMP-IF-FALSE: 6, *BOOL, *INST_PTR
    when 6
      if @at.lookup(addrs[0], modes[0]) == 0
        @counter = @at.lookup(addrs[1], modes[1])
      else
        @counter += 3
      end

      # LESS-THAN: 7, *X, *Y, *(X<Y?1:0)
    when 7
      catch_fire if modes[2] == 1
      result = @at.lookup(addrs[0], modes[0]) < @at.lookup(addrs[1], modes[1]) ? 1 : 0
      @at.write(addrs[2], modes[2], result)
      @counter += 4

      # EQUALS: 8, *X, *Y, *(X=Y?1:0)
    when 8
      catch_fire if modes[2] == 1
      result = @at.lookup(addrs[0], modes[0]) == @at.lookup(addrs[1], modes[1]) ? 1 : 0
      @at.write(addrs[2], modes[2], result)
      @counter += 4

      # UPDATE OFFSET: 9 *OFFSET
    when 9
      @at.offset += @at.lookup(addrs[0], modes[0])
      @counter += 2

      # HALT: 99
    when 99
      halt
      @counter += 1

    else
      catch_fire("opcode: #{opcode}")
    end
  end

  def output_current_instruction
    (opcode, modes, addrs) = fetch_instruction
    string = "op: #{opcode}"
    for i in (0..modes.length-1) do
      string << " - #{modes[i]},#{addrs[i]}, (#{@at.lookup(addrs[i],modes[i])})"
    end
    puts string
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

