class World

  def initialize
    @painted = Hash.new(0)
    paint(1, [0,0])
  end

  def sense(coords)
    @painted[coords]
  end

  def paint(color, coords)
    @painted[coords] = color
  end

  def painted_squares
    @painted.size
  end

  def pretty_print
    max_x = 0
    max_y = 0
    min_x = 0
    min_y = 0

    @painted.each do |square|
      max_x = square[0][0] if square[0][0] > max_x
      min_x = square[0][0] if square[0][0] < min_x
      max_y = square[0][1] if square[0][1] > max_y
      min_y = square[0][1] if square[0][1] < min_y
    end

    strings = []
    for y in (min_y..max_y) do
      string = ""
      for x in (min_x..max_x) do
        if @painted.include?([x,y]) && @painted[[x,y]] == 1
          string << "#"
        else
          string << "."
        end
      end
      strings << string
    end
    strings.reverse
  end
end
