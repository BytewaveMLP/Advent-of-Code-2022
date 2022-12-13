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
    left += ([nil] * size_diff) if size_diff.positive?

    left.zip(right).each do |left_el, right_el|
      return -1 if left_el.nil?
      return 1 if right_el.nil?

      comparison = compare(left_el, right_el)
      next if comparison.zero?

      return comparison
    end

    0
  when [Integer, Array]
    compare([left], right)
  when [Array, Integer]
    compare(left, [right])
  when [Integer, Integer]
    left <=> right
  end
end

packets = []

while $input.any?
  lines = $input.shift(2)
  packets << lines.map(&method(:parse_line))
  $input.shift
end

sum = 0

packets.each_with_index.map do |pair, i|
  one = pair.first
  two = pair.last

  comparison = compare(one, two)
  puts(comparison)
  sum += pp(i + 1) if comparison.negative?

  puts
end

puts(sum)
