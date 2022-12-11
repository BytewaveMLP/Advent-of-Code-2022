# frozen_string_literal: true

require_relative '../lib/prelude'

class Monkey
  attr_accessor :items
  attr_reader :operation, :worry_test, :throw_to

  def initialize(items, operation, worry_test, throw_to)
    @items = items
    @operation = operation
    @worry_test = worry_test
    @throw_to = throw_to
  end
end

monkeys = []
items = nil
operation = nil
worry_test = nil
throw_to = []
constant = 1

$input.each do |line|
  line = line.strip

  if line.starts_with?('Monkey ')
    items = nil
    operation = nil
    worry_test = nil
    throw_to = []
  elsif line.starts_with?('Starting items: ')
    items = line[16..].split(', ').map(&:to_i)
  elsif line.starts_with?('Operation: ')
    operation = line[11..]
    operation =~ /new = old (\+|\*) (.+)/
    operator = Regexp.last_match(1)
    operand = Regexp.last_match(2)

    operation = ->(old) { old.public_send(operator, operand == 'old' ? old : operand.to_i) }
  elsif line.starts_with?('Test: ')
    worry_test = line[6..]
    worry_test =~ /(\d+)$/
    worry_test_mod = Regexp.last_match(1).to_i
    constant *= worry_test_mod
    worry_test = ->(worry_level) { (worry_level % worry_test_mod).zero? }
  elsif line.starts_with?('If')
    line =~ /(\d+)$/
    throw_to << Regexp.last_match(1).to_i
  elsif line.blank?
    monkeys << Monkey.new(items, operation, worry_test, throw_to)
  end
end

monkeys << Monkey.new(items, operation, worry_test, throw_to)

total_inspects = Array.new(monkeys.size, 0)

ap monkeys

10_000.times do |round|
  puts("Round #{round + 1}")
  monkeys.each_with_index do |monkey, monkey_index|
    total_inspects[monkey_index] += monkey.items.size
    # puts("  Monkey #{monkey_index}")
    monkey.items.each do |item|
      # puts("    inspecting #{item}")
      item = monkey.operation.call(item) % constant
      # puts("    new worry level: #{item}")
      is_worried = monkey.worry_test.call(item)
      # puts("    is worried: #{is_worried}")
      throw_to = monkey.throw_to[is_worried ? 0 : 1]
      # puts("    throw to: #{throw_to}")
      monkeys[throw_to].items << item
    end
    monkey.items = []
  end
end

puts("Total inspects: #{total_inspects}")
puts("Most active sum: #{total_inspects.max(2).reduce(:*)}")
