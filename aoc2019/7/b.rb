require "./intcode"

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
program = read_program(ARGV[0])

class Amplifier
  def initialize(program)
    @program = Program.new(program)
  end

  def process(input, output)
    return @program.process(input, output)
  end
end

def try_phases(program, phases)

  amps = (0..4).map { |_| Amplifier.new(program) }
  pipes = (0..4).map do |i|
    new_pipe = IO.pipe
    new_pipe[1].write("#{phases[i]},")
    new_pipe
  end
  pipes[0][1].write("0,")

  count = 0 
  current_amp = 0
  loop do
    pipes[current_amp][1].close
    code = amps[current_amp].process(pipes[current_amp][0], pipes[next_amp(current_amp)][1])
    pipes[current_amp][0].close
    pipes[current_amp] = IO.pipe
    current_amp = next_amp(current_amp)
    break if code != 1 && current_amp == 0
    count += 1
  end
  pipes[current_amp][1].close
  output = pipes[current_amp][0].read
  output.to_i
end

def next_amp(i)
  (i+1) % 5
end

perms = '56789'.chars.permutation.map(&:join)

puts perms.map { |phases| try_phases(program, phases.chars).to_i }.max
