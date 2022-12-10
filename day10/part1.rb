# frozen_string_literal: true

require_relative '../lib/prelude'

LINE_ENDS = 20.step(220, 40).to_a.freeze

signal_strength_sum = 0

cycles = 0
x = 1

$input.each do |line|
  instr, *args = line.split
  case instr
  when 'noop'
    cycles += 1
    if cycles.in?(LINE_ENDS)
      signal_strength = cycles * x
      puts("Cycle #{cycles}: #{x} - #{signal_strength}")
      signal_strength_sum += signal_strength
    end
  when 'addx'
    # puts("addx #{args[0]}")
    cycles += 1
    if cycles.in?(LINE_ENDS)
      puts("Signal strength sample crossed add cycle boundary: #{cycles}")
      signal_strength = cycles * x
      puts("Cycle #{cycles}: #{x} - #{signal_strength}")
      signal_strength_sum += signal_strength
    end
    cycles += 1
    if cycles.in?(LINE_ENDS)
      signal_strength = cycles * x
      puts("Cycle #{cycles}: #{x} - #{signal_strength}")
      signal_strength_sum += signal_strength
    end
    x += args[0].to_i
    # puts(x)
  end
end

puts(signal_strength_sum)
