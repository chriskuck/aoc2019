require 'pry'
require './intcode/machine'
require './world'
require './robot'

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
program = File.read(ARGV[0])

machine = Machine.new(program)
world = World.new
robot = Robot.new(machine)
robot.go(world)
puts world.pretty_print

