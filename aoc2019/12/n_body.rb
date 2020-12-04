require 'set'
require 'pry'
require './moons'

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
positions = File.read(ARGV[0])

moons = Moons.new(positions)

states = [Hash.new,Hash.new,Hash.new]
reps = [[],[],[]]

binding.pry
for i in (0..231615) do

  # get vectors for all moon axis positions
  all_axes = moons.axis_positions

  # look in state bucket for match
  repitition = states.each_with_index.map { |state_bucket, j| state_bucket.include? all_axes[j] }

  # if we found a match, record the turn we found it in
  #repitition.each_with_index { |found, j| reps[j] << i if found == true }

  # debugging garbage
  #binding.pry if i % 1000 == 0
  #break if reps.all? { |r| r..nil? }

  # otherwise, record the state
  all_axes.each_with_index { |axis, j| 

    states[j][axis] ||= []
    states[j][axis] << i
  }

  # step the simulation
  moons.step

end

binding.pry
puts "hi"
