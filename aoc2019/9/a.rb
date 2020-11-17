require "./intcode/machine"
require 'stringio'
require 'pry'

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
program = File.read(ARGV[0])

[2].each{ |code|
  input = StringIO.new("#{code},")
  output = StringIO.new
  Machine.new(program).process(input, output)
  puts output.string
}


