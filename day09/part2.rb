# frozen_string_literal: true

require_relative '../lib/prelude'

class Integer
  def sign
    self <=> 0
  end
end

class Vector
  attr_reader :x, :y

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

  def to_grid
    Vector.new(x.sign, y.sign)
  end

  def hash
    [x, y].hash
  end

  def inspect
    to_str
  end
end

KNOT_COUNT = 10

knot_poses = KNOT_COUNT.times.map { Vector.new(0, 0) }

unique_tail_pos = Set.new([Vector.new(0, 0)])

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

  puts line

  direction = DIRECTION_VECTORS[direction]
  distance = distance.to_i

  distance.times do
    knot_poses[0] += direction

    knot_poses[1..].each_with_index do |knot_pos, index|
      head_pos = knot_poses[index]

      offset = head_pos - knot_pos
      next if GRID_AROUND_OFFSETS.include?(offset)

      if offset.x.zero?
        knot_poses[index + 1] = Vector.new(knot_pos.x, head_pos.y - offset.y.sign)
      elsif offset.y.zero?
        knot_poses[index + 1] = Vector.new(head_pos.x - offset.x.sign, knot_pos.y)
      else
        # diagonally offset
        knot_poses[index + 1] = knot_pos + offset.to_grid
      end

      unique_tail_pos << knot_poses.last
    end
  end
end

puts unique_tail_pos.size
