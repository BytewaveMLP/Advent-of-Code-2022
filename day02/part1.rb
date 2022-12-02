# frozen_string_literal: true

require_relative '../lib/prelude'

MY_MOVES = 'XYZ'
ELF_MOVES = 'ABC'

ROUND_OUTCOME_POINTS = {
  win:  6,
  draw: 3,
  loss: 0
}.freeze

def round_outcome(elf_move, my_move)
  case [elf_move, my_move]
  when %w[A Y], %w[B Z], %w[C X]
    :win
  when %w[A Z], %w[B X], %w[C Y]
    :loss
  else
    :draw
  end
end

def round_score(elf_move, my_move)
  ROUND_OUTCOME_POINTS[round_outcome(elf_move, my_move)] +
    MY_MOVES.index(my_move) + 1
end

scores = $input.map do |line|
  elf_move, my_move = line.split
  round_score(elf_move, my_move)
end

puts scores.sum
