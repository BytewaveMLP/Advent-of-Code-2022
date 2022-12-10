# frozen_string_literal: true

require_relative '../lib/prelude'

LINE_ENDS = 40.step(240, 40).to_a.freeze

cycles = 0
x = 1

def draw_px(x, cycles)
  if cycles.in?(x - 1..x + 1)
    print '#'
  else
    print '.'
  end

  cycles += 1
  puts if cycles.in?(LINE_ENDS)

  cycles % 40
end

$input.each do |line|
  instr, *args = line.split
  case instr
  when 'noop'
    cycles = draw_px(x, cycles)
  when 'addx'
    cycles = draw_px(x, cycles)
    cycles = draw_px(x, cycles)
    x += args[0].to_i
  end
end
