# frozen_string_literal: true

require_relative '../lib/prelude'

require 'matrix'

$input = $input.to_a.first

ROCK_COUNT = 2022

CAVE_WIDTH = 7

ROCK_SHAPES = [
  [
    Vector[0, 0],
    Vector[1, 0],
    Vector[2, 0],
    Vector[3, 0]
  ],
  [
    Vector[1, 2],
    Vector[0, 1],
    Vector[1, 1],
    Vector[2, 1],
    Vector[1, 0]
  ],
  [
    Vector[2, 2],
    Vector[2, 1],
    Vector[0, 0],
    Vector[1, 0],
    Vector[2, 0]
  ],
  [
    Vector[0, 3],
    Vector[0, 2],
    Vector[0, 1],
    Vector[0, 0]
  ],
  [
    Vector[0, 1],
    Vector[1, 1],
    Vector[0, 0],
    Vector[1, 0]
  ]
].freeze

ROCK_SPAWN_X = 2
ROCK_SPAWN_Y_OFFSET = 3

occupied_positions = Set.new

rock_spawn_y = ROCK_SPAWN_Y_OFFSET

jet_movements = $input.each_char.cycle

def min_x(rock_shape)
  rock_shape.map { |v| v[0] }.min
end

def max_x(rock_shape)
  rock_shape.map { |v| v[0] }.max
end

def min_y(rock_shape)
  rock_shape.map { |v| v[1] }.min
end

def max_y(rock_shape)
  rock_shape.map { |v| v[1] }.max
end

tower_height = 0

def print_cave(occupied_positions, max_y)
  (max_y..0).step(-1).each do |y|
    print('|')
    (0...CAVE_WIDTH).each do |x|
      if occupied_positions.include?(Vector[x, y])
        print('#')
      else
        print('.')
      end
    end
    puts('|')
  end
  puts("+#{'-' * CAVE_WIDTH}+")
  puts
end

ROCK_SHAPES.cycle.each_with_index do |rock_shape, rock_number|
  break if rock_number == ROCK_COUNT

  rock_position = Vector[ROCK_SPAWN_X, rock_spawn_y]
  rock_shape = rock_shape.map { |position| position + rock_position }
  puts("Rock #{rock_number} spawned at #{rock_position}")

  loop do
    movement = jet_movements.next

    # all_positions = occupied_positions.dup.merge(rock_shape)
    # print_cave(all_positions, max_y(all_positions))

    case movement
    when '<'
      rock_position -= Vector[1, 0]
      new_rock_shape = rock_shape.map { |position| position - Vector[1, 0] }
      unless min_x(new_rock_shape).negative? || occupied_positions.intersect?(new_rock_shape)
        rock_shape = new_rock_shape
      end
    when '>'
      rock_position += Vector[1, 0]
      new_rock_shape = rock_shape.map { |position| position + Vector[1, 0] }
      unless max_x(new_rock_shape) >= CAVE_WIDTH || occupied_positions.intersect?(new_rock_shape)
        rock_shape = new_rock_shape
      end
    else
      raise ArgumentError, "Unknown movement: #{movement}"
    end

    puts("Movement: #{movement}")

    rock_position -= Vector[0, 1]
    new_rock_shape = rock_shape.map { |position| position - Vector[0, 1] }

    break if occupied_positions.intersect?(new_rock_shape) || min_y(new_rock_shape).negative?

    rock_shape = new_rock_shape
  end

  puts("Rock #{rock_number} landed at #{rock_position}")
  puts
  occupied_positions.merge(rock_shape)

  tower_height = [max_y(rock_shape) + 1, tower_height].max
  rock_spawn_y = tower_height + ROCK_SPAWN_Y_OFFSET
end

puts(tower_height)
