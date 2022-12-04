# frozen_string_literal: true

require_relative '../lib/prelude'

puts($input.map do |line|
  assignments = line.split(',').map do |assignment|
    first, last = assignment.split('-').map(&:to_i)
    (first..last)
  end

  if assignments[0].cover?(assignments[1]) || assignments[1].cover?(assignments[0])
    1
  else
    0
  end
end.sum(0))
