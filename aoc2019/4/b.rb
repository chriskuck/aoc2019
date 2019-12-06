
def double_digits?(i)
  c = i.to_s.chars().each_with_object(Hash.new(0)) { |o, h| h[o] += 1 }
  n = c.select {|c,v| v == 2 }.size
  n > 0
end

def increasing?(i)
  base = 0
  for d in i.to_s.split('')
    return false if base > d.to_i
    base = d.to_i
  end
  return true
end

puts (128392..643281).to_a.select { |d| increasing?(d) && double_digits?(d) }.count
