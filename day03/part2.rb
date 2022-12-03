# frozen_string_literal: true

require_relative '../lib/prelude'

PRIORITY_MAP = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

puts($input.each_slice(3).map do |lines|
  intersection = lines.map { |line| Set.new(line.chars) }.reduce(:&).to_a.first
  PRIORITY_MAP.index(intersection) + 1
end.sum(0))
