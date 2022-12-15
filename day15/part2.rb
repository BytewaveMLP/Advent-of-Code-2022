# frozen_string_literal: true

require_relative '../lib/prelude'

POS_REGEXP = /x=(-?\d+), y=(-?\d+)/.freeze

FINAL_X = 4_000_000
BEACON_SEARCH_WINDOW = (0..FINAL_X).freeze

Sensor = Struct.new(:x, :y, :closest_beacon_distance)

sensors = []
beacon_poses = Set.new

$input.each do |line|
  match = line.scan(POS_REGEXP)
  sensor_pos = match[0].map(&:to_i)
  beacon_pos = match[1].map(&:to_i)
  sensor = Sensor.new(*sensor_pos, (sensor_pos[0] - beacon_pos[0]).abs + (sensor_pos[1] - beacon_pos[1]).abs)
  sensors << sensor
  beacon_poses << beacon_pos
end

def project_radius_line(sensor, target_y)
  line_length = sensor.closest_beacon_distance - (target_y - sensor.y).abs
  return [] if line_length.negative?

  [sensor.x - line_length, sensor.x + line_length]
end

def turing_frequency(pos)
  (FINAL_X * pos[0]) + pos[1]
end

def combine_ranges(range1, range2)
  return range2 if range1.blank?

  min_range_by_start = [range1, range2].min_by(&:first)
  max_range_by_end = [range1, range2].max_by(&:last)

  return nil unless min_range_by_start.include?(max_range_by_end.first)
  return nil unless max_range_by_end.include?(min_range_by_start.last)

  min_range_by_start.first..max_range_by_end.last
end

BEACON_SEARCH_WINDOW.each do |y|
  projected_lines = []

  sensors.each do |sensor|
    projected_line = project_radius_line(sensor, y)
    next unless projected_line.present?

    projected_line[0] = 0 if projected_line[0].negative?
    projected_line[1] = BEACON_SEARCH_WINDOW.last if projected_line[1] > BEACON_SEARCH_WINDOW.last

    projected_line_range = projected_line[0]..projected_line[1]

    projected_lines << projected_line_range
  end

  projected_lines = projected_lines.sort_by(&:first)

  combined = projected_lines.each_with_object([]) do |range, combined_ranges|
    previous_range = combined_ranges.last
    if previous_range.blank?
      combined_ranges << range
      next combined_ranges
    end

    combined_range = combine_ranges(combined_ranges.last, range)

    if combined_range.present?
      combined_ranges[-1] = combined_range
    else
      combined_ranges << range
    end
  end

  next unless combined.size != 1

  x = combined.first.last + 1

  puts turing_frequency([x, y])
  break
end
