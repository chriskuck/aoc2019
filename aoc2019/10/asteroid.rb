require 'pry'
require 'set'

class Asteroid

  def initialize(map)
    @map = parse_map(map)
  end

  def rows
    @map.length
  end

  def cols
    @map[0].length
  end

  def parse_map(map)
    map.split(/\s/)
  end

  def best_base
    answers = {}
    each_asteroid do |x,y|
      answers["#{x},#{y}"] = determine_number(x,y)
    end

    key = answers.key(answers.values.max)
    { base: key.split(',').map(&:to_i), in_los: answers[key].to_i }
  end

  def shoot(base_coords, angle)
    shot_order = []
    infos = []

    # for each asteroid make a hash of information about it (angle, distance and coord)
    each_asteroid do |x,y|
      next if x == base_coords[0] && y == base_coords[1]
      infos << {
        angle: angle(base_coords[0], base_coords[1],x,y),
        distance: distance(base_coords[0], base_coords[1],x,y),
        coord: [x,y]
      }
    end

    #rotate by 1.5pi
    infos.each do |info|
      info[:angle] += 0.5*Math::PI
      info[:angle] += 2*Math::PI if info[:angle] < 0
    end


    infos.each do |info|
      info[:angle] = info[:angle] % (Math::PI*2)
    end

    # create a bucketized list of the infos
    angle_list = {}
    infos.each do |info|
      angle_list[info[:angle]] ||= []
      angle_list[info[:angle]] << info
    end

    # sort the buckets by distance from base
    angle_list = angle_list.map { |angle_entry, infos| [angle_entry, infos.sort_by { |e| e[:distance] }] }.to_h

    # sort the list of buckets by angle
    sorted_angle_list = angle_list.sort.to_h

    # iterate over buckets -- and take out nth element, if no nth element skip it
    i = 0
    number_shot = 0
    done = false
    shot_order = []
    while !done do
      sorted_angle_list.each do |k,v|
        shot_order << v[i][:coord] if i < v.length
        number_shot += 1 if i < v.length
      end

      done = number_shot == 0
      number_shot = 0
      i += 1
    end

    shot_order
  end

  def determine_number(x,y)
    return -1 if @map[y][x] == '.'

    angles = Set.new
    each_asteroid do |x1,y1|
      next if x1 == x && y1 == y
      angles << angle(x,y,x1,y1)
    end
    angles.size
  end

  def each_asteroid
    for y in (0..@map.length-1) do
      for x in (0..@map[y].length-1) do
        yield x, y if @map[y][x] == '#'
      end
    end
  end

  def angle(x,y,x1,y1)
    Math.atan2(y1-y, x1-x)
  end

  def distance(x,y,x1,y1)
    Math.sqrt((x1-x)*(x1-x)+(y1-y)*(y1-y))
  end

  def output_pretty_map(coords, override = nil)
    map = []
    (0..(rows-1)).each { |y|
      map[y] = ""
      (0..(cols-1)).each { |x|
        key = "#{x},#{y}"
        value = coords[key] unless override
        value = override if coords.include?(key) && override
        value = '.' if value.nil?
        map[y] << value.to_s
      }
    }
    puts map
  end
end
