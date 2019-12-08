require "./intcode-b"
require 'pry'

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
program = read_program(ARGV[0])

class Amplifier
  def initialize(program)
    @program = Program.new(program)
    @next_input = ''
  end

  def process
    input = StringIO.new()
    puts "input: #{@next_input}"
    input.write(@next_input)
    input.rewind
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
    .each_with_index { |amp, index| amp.send_input(phases[index]+',') }

  amps[0].send_input('0,')
  current_amp = 0
  real_output = ''
  loop do
    (code, output) = amps[current_amp].process
    puts amps[current_amp].inspect
    current_amp = (current_amp + 1) % 5
    amps[current_amp].send_input(output)
    real_output = output
    puts "code:#{code} output:#{output} amp:#{current_amp}"
    break if code != 1 && current_amp == 0
  end
  real_output
end

perms = '56789'.chars.permutation.map(&:join)

puts perms.map { |phases| try_phases(program, phases.chars).to_i }.max
