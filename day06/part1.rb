# frozen_string_literal: true

require_relative '../lib/prelude'

WINDOW_SIZE = 4

input = $input.first

(0...input.size - WINDOW_SIZE).each do |i|
  next unless Set.new(input[i...i + WINDOW_SIZE].chars).size == WINDOW_SIZE

  puts(i + WINDOW_SIZE)
  puts(input[i...i + WINDOW_SIZE])
end
