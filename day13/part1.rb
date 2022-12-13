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
  packets << lines.map(&method(:parse_line))
  $input.shift
end

sum = 0

packets.each_with_index.map do |pair, i|
  one = pair.first
  two = pair.last

  comparison = compare(one, two)
  puts(comparison)
  sum += pp(i + 1) if comparison

  puts
end

puts(sum)
