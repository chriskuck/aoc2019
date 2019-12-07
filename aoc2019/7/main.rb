require "./b"

exit(1) unless File.exists(ARGV[0])
program = read_program(ARGV[0])
Program.new(program)
