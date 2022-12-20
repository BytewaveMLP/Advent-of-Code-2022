# frozen_string_literal: true

require_relative '../lib/prelude'

$input = $input.map(&:to_i).to_a

COORDS_OFFSETS = [1000, 2000, 3000].freeze

output = $input.dup

ap $input.size
ap Set.new($input).size

$input.each do |n|
  next if n.zero?

  offset_unmod = output.index(n) + n
  if offset_unmod >= $input.size
    offset_unmod += 1
  elsif offset_unmod <= 0
    offset_unmod -= 1
  end
  offset = offset_unmod % $input.size

  output.delete(n)
  output.insert(offset, n)

  if output[offset + 1].nil?
    ap output
    raise 'oh no'
  end
end

ap output

zero_index = output.index(0)

puts(COORDS_OFFSETS.map do |offset|
  output[(zero_index + offset) % output.size]
end.sum)
