require "./b"

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
program = read_program(ARGV[0])

def try_phases(program, phases)
  previous_output = '0\n'
  for i in (0..4) do
    input = StringIO.new()
    output = StringIO.new()
    input.write(phases[i]+",")
    input.write(previous_output)
    input.rewind
    Program.new(program, input, output).process
    output.rewind
    previous_output = output.read
    puts "prev[#{i}]: #{previous_output}"
  end
  return previous_output
end

perms = '01234'.chars.permutation.map(&:join)

puts perms.map { |phases| try_phases(program, phases.chars).to_i }.max
