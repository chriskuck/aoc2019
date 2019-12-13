require 'pry'

def halt
  puts "ERROR: exiting b/c of input"
  exit(1)
end

def file_valid(filename)
  !filename.nil? && File.file?(filename)
end

halt if !file_valid(ARGV[0])
data = File.read(ARGV[0]).strip.chars

width = ARGV[1].to_i || 25
height = ARGV[2].to_i || 6

layer_size = width * height
layers = data.length / layer_size

sliced_data = data.each_slice(width).to_a.each_slice(height).to_a

zero_counts = sliced_data.map { |a| a.flatten }.map { |a| a.count {|d| d == "0" } }
index = zero_counts.each_with_index.map { |a, i| (a == zero_counts.min) ? i : nil}.compact[0]

layer_zero_min = sliced_data[index].flatten
puts layer_zero_min.count{ |d| d == "1" } * layer_zero_min.count { |d| d == "2" }
