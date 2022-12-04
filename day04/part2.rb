# frozen_string_literal: true

require_relative '../lib/prelude'

puts($input.map do |line|
  assignments = line.split(',').map do |assignment|
    first, last = assignment.split('-').map(&:to_i)
    Set.new(first..last)
  end

  if assignments.reduce(:&).size.positive?
    1
  else
    0
  end
end.sum(0))
