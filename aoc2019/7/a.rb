require "./intcode"

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
program = read_program(ARGV[0])

def try_phases(program_def, phases)

  pipes = (0..5).map {|i| IO.pipe }
  phases.each_with_index { |phase,i| pipes[i][1].write("#{phase},") }
  pipes[0][1].write('0\n')
  pipes[0][1].close

  for i in (0..4)
    Program.new(program_def).process(pipes[i][0], pipes[i+1][1])
    pipes[i+1][1].close
  end

  output = pipes[5][0].read()
  pipes[5][0].close
  output
end

def get_input(program_def, machine, input, output)
end

def close_input(machine, output)
  output.close if machine != -1
end

perms = '01234'.chars.permutation.map(&:join)
puts perms.map { |phases| try_phases(program, phases.chars).to_i }.max
