require '../asteroid'

RSpec.describe "asteroids" do

  subject { Asteroid.new(map).best_base }
  context "simple map" do
    let(:map) {
".#..#
.....
#####
....#
...##"
    }

    it 'reports 5 rows' do
      expect(Asteroid.new(map).rows).to eq 5
    end

    it 'reports 5 columns' do
      expect(Asteroid.new(map).cols).to eq 5
    end

    it 'produces 3,4:8' do
      expect(subject[:base]).to eq [3,4]
      expect(subject[:in_los]).to eq 8
    end
  end

  context "another map" do
    let(:map) {
"......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####"
    }
    it 'produces 5,8:33' do
      expect(subject[:base]).to eq [5,8]
      expect(subject[:in_los]).to eq 33
    end
  end

  context "another map" do
    let(:map) {
"#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###."
    }
    it 'produces 1,2:35' do
      expect(subject[:base]).to eq [1,2]
      expect(subject[:in_los]).to eq 35
    end
  end

  context "another map" do
    let(:map) {
".#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#.."
    }
    it 'produces 6,3:41' do
      expect(subject[:base]).to eq [6,3]
      expect(subject[:in_los]).to eq 41
    end
  end

  context "bigger map" do
    let(:map) {
".#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##"
    }
    it 'produces 11,13:210' do
      expect(subject[:base]).to eq [11,13]
      expect(subject[:in_los]).to eq 210
    end

    context "now we shoot" do
      subject { Asteroid.new(map).best_base.shoot }
      it 'shoots 11,12 first' do
        expect(subject).to eq [11,12]
      end
    end
  end
end
