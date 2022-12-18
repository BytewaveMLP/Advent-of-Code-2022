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

cube_positions = Set.new($sides_available.keys)
$dim_extremes = (0..2).map do |dim|
  values_along_dim = cube_positions.map { |v| v[dim] }

  Range.new(-1, values_along_dim.max + 1)
end

visited = Set.new
queue = Queue.new
queue << Vector[-1, -1, -1]

exterior_surface_area = 0

until queue.empty?
  current = queue.pop

  [-1, 1].each do |offset|
    if current[0] + offset >= $dim_extremes[0].begin && current[0] + offset <= $dim_extremes[0].end
      offset_pos = current + Vector[offset, 0, 0]
      if cube_positions.include?(offset_pos)
        exterior_surface_area += 1
      elsif !visited.include?(offset_pos)
        queue << offset_pos
        visited << offset_pos
      end
    end

    if current[1] + offset >= $dim_extremes[1].begin && current[1] + offset <= $dim_extremes[1].end
      offset_pos = current + Vector[0, offset, 0]
      if cube_positions.include?(offset_pos)
        exterior_surface_area += 1
      elsif !visited.include?(offset_pos)
        queue << offset_pos
        visited << offset_pos
      end
    end

    next unless current[2] + offset >= $dim_extremes[2].begin && current[2] + offset <= $dim_extremes[2].end

    offset_pos = current + Vector[0, 0, offset]
    if cube_positions.include?(offset_pos)
      exterior_surface_area += 1
    elsif !visited.include?(offset_pos)
      queue << offset_pos
      visited << offset_pos
    end
  end
end

puts(exterior_surface_area)
