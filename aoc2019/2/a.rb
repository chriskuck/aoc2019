class Program
  def initialize(program)
    @program = program
  end

  def []=(*args)
    @program[args[0]] = args[1]
  end

  def [](*args)
    return @program[args[0]]
  end

  def process
    counter = 0
    while peekop(counter) do
      op = getop(counter).process
      counter = counter + 1
    end

    return @program.join(",")
  end

  private

  def getop(c)
    opcode = peekop(c)
    case opcode
      when "1"
        return AddOp.new(@program, @program[c*4,c*4+4])
      when "2"
        return MultOp.new(@program, @program[c*4,c*4+4])
      else
        puts "error opcode: #{opcode}"
      end
  end

  def peekop(c)
    return nil if c*4 > @program.size
    return nil if @program[c*4] == "99"
    return @program[c*4]
  end
end

class AddOp
  def initialize(program, op_ar)
    @program = program
    @op_ar = op_ar
  end
  def process
    @program[@op_ar[3].to_i] = (@program[@op_ar[1].to_i].to_i + @program[@op_ar[2].to_i].to_i).to_s
  end
end

class MultOp
  def initialize(program, op_ar)
    @program = program
    @op_ar = op_ar
  end
  def process
    @program[@op_ar[3].to_i] = (@program[@op_ar[1].to_i].to_i * @program[@op_ar[2].to_i].to_i).to_s
  end
end

program = STDIN.read.strip.split(",")
program[1] = "12"
program[2] = "2"
puts Program.new(program).process

