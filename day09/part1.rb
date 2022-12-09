# frozen_string_literal: true

require_relative '../lib/prelude'

class Vector
  attr_reader :x
  attr_reader :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Vector.new(x + other.x, y + other.y)
  end

  def -(other)
    Vector.new(x - other.x, y - other.y)
  end

  def eql?(other)
    x == other.x && y == other.y
  end

  def ==(other)
    eql?(other)
  end

  def to_str
    "Vector(#{x}, #{y})"
  end

  def to_s
    to_str
  end

  def hash
    [x, y].hash
  end

  def inspect
    to_str
  end
end

head_pos = Vector.new(0, 0)
tail_pos = Vector.new(0, 0)

unique_tail_pos = Set.new([tail_pos])

DIRECTION_VECTORS = {
  'L' => Vector.new(-1, 0),
  'R' => Vector.new(1, 0),
  'U' => Vector.new(0, 1),
  'D' => Vector.new(0, -1)
}.freeze

GRID_AROUND_OFFSETS = [
  Vector.new(-1, -1),
  Vector.new(0, -1),
  Vector.new(1, -1),
  Vector.new(-1, 0),
  Vector.new(0, 0),
  Vector.new(1, 0),
  Vector.new(-1, 1),
  Vector.new(0, 1),
  Vector.new(1, 1)
].freeze

$input.each do |line|
  direction, distance = line.match(/([LRUD]) (\d+)/).captures

  direction = DIRECTION_VECTORS[direction]
  distance = distance.to_i

  distance.times do
    head_pos += direction

    valid_tail_poses = GRID_AROUND_OFFSETS.map { |offset| head_pos + offset }

    tail_pos = head_pos - direction unless valid_tail_poses.include?(tail_pos)

    unique_tail_pos << tail_pos
  end
end

puts unique_tail_pos.size
