# frozen_string_literal: true

require_relative '../lib/prelude'

PRIORITY_MAP = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

puts($input.to_a.map do |line|
  len = line.size
  first  = line[0..(len / 2) - 1]
  second = line[(len / 2)..]

  items_first  = Set.new(first.chars)
  items_second = Set.new(second.chars)

  intersection = (items_first & items_second).to_a.first

  PRIORITY_MAP.index(intersection) + 1
end.sum(0))
