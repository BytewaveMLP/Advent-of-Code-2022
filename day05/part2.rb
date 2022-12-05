# frozen_string_literal: true

require_relative '../lib/prelude'

crate_stacks = []

def print_crates(crate_stacks)
  max_height = crate_stacks.max_by(&:size).size

  max_height.times do |i|
    crate_lines = crate_stacks.map do |stack|
      stack[i] || ' '
    end
    puts crate_lines.join(' ')
  end
end

$input.take_while { |line| line != '' }.each do |line|
  matches = line.scan(/(    |\[(\w)\] ?)/)

  ap line
  ap matches

  matches.each_with_index do |match, index|
    unless match[1].nil?
      crate_stacks[index] ||= []
      crate_stacks[index] << match[1]
    end
  end
end

print_crates crate_stacks

$input.each do |instruction|
  ap instruction
  amount, from, to = instruction.scan(/move (\d+) from (\d+) to (\d+)/).first.map(&:to_i)

  crate_stacks[to - 1] ||= []
  crate_stacks[to - 1].unshift(*crate_stacks[from - 1].shift(amount))
  print_crates crate_stacks
end

puts(crate_stacks.reduce('') do |acc, stack|
  acc + stack.first
end)
