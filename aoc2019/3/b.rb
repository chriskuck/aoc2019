
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

    line.split(',').each do |p|
      points << make_point(p[0], p[1..-1], points[-1])
      segments << make_segment(points[-2], points[-1])
    end
    lines << segments
  end
  lines
end

def intersect(s1, s2)
  if s1[0][0] == s1[1][0] && s2[0][1] == s2[1][1]
    x_ap = (s2[0][0] <= s1[0][0] && s1[0][0] <= s2[1][0]) || (s2[1][0] <= s1[0][0] && s1[0][0] <= s2[0][0])
    y_ap = (s1[0][1] <= s2[0][1] && s2[0][1] <= s1[1][1]) || (s1[1][1] <= s2[0][1] && s2[0][1] <= s1[0][1])
    return [s1[0][0],s2[0][1]] if x_ap && y_ap
  end

  if s1[0][1] == s1[1][1] && s2[0][0] == s2[1][0]
    x_ap = (s1[0][0] <= s2[0][0] && s2[0][0] <= s1[1][0]) || (s1[1][0] <= s2[0][0] && s2[0][0] <= s1[0][0])
    y_ap = (s2[0][1] <= s1[0][1] && s1[0][1] <= s2[1][1]) || (s2[1][1] <= s1[0][1] && s1[0][1] <= s2[0][1])
    return [s2[0][0], s1[0][1]] if x_ap && y_ap
  end

  #ns1 = [ s1[1][0] - s1[0][0], s1[1][1] - s1[0][1] ]
  #ns2 = [ s2[1][0] - s2[0][0], s2[1][1] - s2[0][1] ]

  #d = (-ns2[0] * ns1[1] + ns1[0] * ns2[1] )

  #return nil if d == 0

  #s = ( -ns1[1] * (s1[0][0] - s2[0][0]) + ns1[0] * (s1[0][1] - s2[0][1]) ) / d
  #t = (  ns2[0] * (s1[0][1] - s2[0][1]) - ns2[1] * (s1[0][0] - s2[0][0]) ) / d

  #if s >= 0 && s <=1 && t >= 0 && t <=1
  #  return [ s1[0][0] + (t * ns1[0]), s1[0][1] + (t * ns1[1]) ]
  #end

  nil
end

def distance(p1, p2)
  (p2[0]-p1[0]).abs + (p2[1]-p1[1]).abs
end


def cross_segments(lines)
  lengths = []
  puts "error" && exit(1) if lines.size > 2

  lines[0].each_with_index do |x, i|
    lines[1].each_with_index do |y, j|
      point = intersect(x,y)
      if !point.nil? && (point != [0.0, 0.0])
        # oh boy, make some math

        sum = 0
        lines[0][0..i-1].each {|p| sum = sum + distance(p[0],p[1]) } if i > 0
        sum = sum + distance(lines[0][i][0], point)
        t_sum = 0
        lines[1][0..j-1].each {|p| t_sum = t_sum + distance(p[0],p[1]) } if j > 0
        t_sum = t_sum + distance(lines[1][j][0], point)

        lengths << sum + t_sum

      end
    end
  end
  lengths
end


def get_min_distance(distances)
  distances.min if !distances.nil? and distances.size > 0
end

input = read_input()
lines = read_segments(input)
distances = cross_segments(lines)
puts get_min_distance(distances)
