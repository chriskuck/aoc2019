require "./intcode"

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
program = read_program(ARGV[0])

class Amplifier
  def initialize(program)
    @program = Program.new(program,@input, @output)
    @next_input = ''
  end

  def process
    input = StringIO.new().write(@next_input)
    @next_input = ''
    output = StringIO.new()
    code = @program.process(input, output)
    output.rewind
    [code, output.read]
  end

  def send_input(value)
    @next_input << value
  end
end

def try_phases(program, phases)
  amps = (0..4).map { |_| Amplifier.new(program) }
    .each_with_index { |amp, index| amp.send_input(phases[index]) }
  previous_output = '0\n'
  current_amp = 0

  while
    amps[current_amp].send_input(previous_output)
    (code, output) = amps[current_amp].process(input)
    previous_output = output
    break if code != 1
    current_amp += 1
  end
  return previous_output
end

#perms = '56789'.chars.permutation.map(&:join)

#puts perms.map { |phases| try_phases(program, phases.chars).to_i }.max
