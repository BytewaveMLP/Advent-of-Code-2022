# frozen_string_literal: true

require_relative '../lib/prelude'

elf_calories = []

total = 0
elf_max = 0

$input.each do |line|
  if line.empty?
    elf_calories << total
    elf_max = [elf_max, total].max
    total = 0
    next
  end

  total += line.to_i
end

puts elf_max
