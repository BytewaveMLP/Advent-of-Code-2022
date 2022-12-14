# frozen_string_literal: true

require_relative '../lib/prelude'

$grid = Set.new

$max_y = -1

$input.each do |line|
  rock_points = line.split(' -> ')

  rock_points.each_cons(2) do |rock_line|
    start = rock_line.first.split(',').map(&:to_i)
    finish = rock_line.last.split(',').map(&:to_i)

    $max_y = [$max_y, start.last, finish.last].max

    range_x = [start.first, finish.first].min..[start.first, finish.first].max
    range_y = [start.last, finish.last].min..[start.last, finish.last].max

    range_x.each do |x|
      range_y.each do |y|
        $grid << [x, y]
      end
    end
  end
end

def space_occupied?(pos)
  $grid.include?(pos) || pos[1] > ($max_y + 1)
end

def simulate_sand
  sand_pos = [500, 0]

  sand_count = 0

  loop do
    sand_pos[1] += 1

    sand_pos[0] -= 1 if space_occupied?(sand_pos)
    sand_pos[0] += 2 if space_occupied?(sand_pos)
    next unless space_occupied?(sand_pos)

    # come to rest
    sand_pos[0] -= 1
    sand_pos[1] -= 1

    $grid << sand_pos
    sand_count += 1

    break if sand_pos == [500, 0]

    sand_pos = [500, 0]
  end

  sand_count
end

puts simulate_sand
