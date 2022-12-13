# frozen_string_literal: true

require_relative '../lib/prelude'

def parse_line(line)
  eval(line)
end

$input = $input.to_a

def compare(left, right)
  puts("Comparing #{left} and #{right}")
  case [left.class, right.class]
  when [Array, Array]
    size_diff = right.size - left.size
    left += ([nil] * size_diff) if size_diff > 0

    left.zip(right).each do |left_el, right_el|
      return true if left_el.nil?
      return false if right_el.nil?

      comparison = compare(left_el, right_el)
      next if comparison.nil?

      return comparison
    end

    nil
  when [Integer, Array]
    compare([left], right)
  when [Array, Integer]
    compare(left, [right])
  when [Integer, Integer]
    return true if left < right
    return false if left > right

    nil
  end
end

packets = []

while $input.any?
  lines = $input.shift(2)
  packets += lines.map(&method(:parse_line))
  $input.shift
end

DIVIDER_PACKETS = [[[2]], [[6]]].freeze

packets += DIVIDER_PACKETS

decoder_key = 1

pp(packets.sort do |a, b|
  comparison = compare(a, b)
  next -1 if comparison
  next 1 unless comparison

  0
end).each_with_index do |packet, i|
  decoder_key *= pp(i + 1) if packet.in?(DIVIDER_PACKETS)
end

puts(decoder_key)
