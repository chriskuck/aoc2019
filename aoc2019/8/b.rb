def halt
  puts "ERROR: exiting b/c of input"
  exit(1)
end

def file_valid(filename)
  !filename.nil? && File.file?(filename)
end

def layer_print(layer, width, height)
  for i in (0..height-1) do
    for j in (0..width-1) do
      $stdout.write(" #{layer[i][j]=="2"?' ':layer[i][j]}")
    end
    $stdout.write("\n")
  end
end

halt if !file_valid(ARGV[0])
data = File.read(ARGV[0]).strip.chars

width = ARGV[1].to_i
height = ARGV[2].to_i

layer_size = width * height
layers = data.length / layer_size

sliced_data = data.each_slice(width).to_a.each_slice(height).to_a
output_data = (0..height-1).map { |_| Array.new(width, "2") }

for i in (0..height-1) do
  for j in (0..width-1) do
    for k in (0..layers-1) do
      sample = output_data[i][j] == "2" ? sliced_data[k][i][j] : output_data[i][j]
      output_data[i][j] = sample
    end
  end
end

layer_print(output_data, width, height)
