# frozen_string_literal: true

require_relative '../lib/prelude'

CUBE_OFFSETS = [
  Vector[-1, 0, 0],
  Vector[0, -1, 0],
  Vector[0, 0, -1],
  Vector[1, 0, 0],
  Vector[0, 1, 0],
  Vector[0, 0, 1]
].freeze

$sides_available = {}

$input.each do |line|
  coords = Vector[*line.split(',').map(&:to_i)]
  $sides_available[coords] = 6
end

$sides_available.each_key do |cube_pos|
  CUBE_OFFSETS.each do |offset|
    offset_cube_pos = cube_pos + offset

    $sides_available[cube_pos] -= 1 if $sides_available.key?(offset_cube_pos)
  end
end

puts($sides_available.values.sum)
