# frozen_string_literal: true

require_relative '../lib/prelude'

POS_REGEXP = /x=(-?\d+), y=(-?\d+)/.freeze
TARGET_Y = 2_000_000

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

  (sensor.x - line_length..sensor.x + line_length)
end

xs_inside_lines = Set.new

sensors.each do |sensor|
  projected_line = project_radius_line(sensor, TARGET_Y)
  xs_inside_lines.merge(projected_line.to_a)
  xs_inside_lines -= beacon_poses.filter_map do |pos|
    next unless pos[1] == TARGET_Y

    pos[0]
  end
end

puts xs_inside_lines.size
