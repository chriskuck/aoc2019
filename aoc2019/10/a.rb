require 'pry'
require './asteroid'

exit(1) unless !ARGV[0].nil? && File.exist?(ARGV[0])
map = File.read(ARGV[0])

asteroid = Asteroid.new(map)
base = asteroid.best_base
order = asteroid.shoot(base[:base],0)
puts order[199][0]*100+order[199][1]

