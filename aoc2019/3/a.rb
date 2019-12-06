
def read_input
  STDIN.read.split("\n")
end

def make_point(direction, distance, basis)
  case(direction)
  when 'R'
    return [basis[0]+distance.to_f, basis[1]]
  when 'L'
    return [basis[0]-distance.to_f, basis[1]]
  when 'U'
    return [basis[0], basis[1]+distance.to_f]
  when 'D'
    return [basis[0], basis[1]-distance.to_f]
  end
end

def make_segment(p1, p2)
  [ p1, p2 ]
end

def read_segments(input)
  lines = []
  input.each do |line|
    segments = []
    points = [ [0.0,0.0] ]
    counter = 0

    line.split(',').each do |p|
      points << make_point(p[0], p[1..-1], points[-1])
      segments << make_segment(points[-2], points[-1]) # unless counter == 0
      counter = counter + 1
    end
    lines << segments
  end
  lines
end

def intersect(s1, s2)
  ns1 = [ s1[1][0] - s1[0][0], s1[1][1] - s1[0][1] ]
  ns2 = [ s2[1][0] - s2[0][0], s2[1][1] - s2[0][1] ]

  d = (-ns2[0] * ns1[1] + ns1[0] * ns2[1] )

  return nil if d == 0

  s = ( -ns1[1] * (s1[0][0] - s2[0][0]) + ns1[0] * (s1[0][1] - s2[0][1]) ) / d
  t = (  ns2[0] * (s1[0][1] - s2[0][1]) - ns2[1] * (s1[0][0] - s2[0][0]) ) / d

  if s >= 0 && s <=1 && t >= 0 && t <=1
    return [ s1[0][0] + (t * ns1[0]), s1[0][1] + (t * ns1[1]) ]
  end

  nil
end

def cross_segments(lines)
  intersections = []
  puts "error" && exit(1) if lines.size > 2

  lines[0].each do |x|
    lines[1].each do |y|
      point = intersect(x, y)
      if !point.nil? && (point[0] != 0.0 || point[1] != 0.0)
        intersections << point
      end
    end
  end
  intersections.compact
end

def calc_distances(intersections)
  intersections.map { |p| p[0].abs + p[1].abs }
end

def get_min_distance(distances)
  distances.min if !distances.nil? and distances.size > 0
end

input = read_input()
lines = read_segments(input)
intersections = cross_segments(lines)
distances = calc_distances(intersections)
puts get_min_distance(distances)
