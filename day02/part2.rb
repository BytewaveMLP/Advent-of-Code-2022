# frozen_string_literal: true

require_relative '../lib/prelude'

MY_MOVES = 'XYZ'
ELF_MOVES = 'ABC'

ROUND_OUTCOME_POINTS = {
  win:  6,
  draw: 3,
  loss: 0
}.freeze

ROUND_OUTCOME_OFFSETS = {
  win:   1,
  draw:  0,
  loss: -1
}.freeze

def round_outcome(my_move)
  case my_move
  when 'Z'
    :win
  when 'X'
    :loss
  else
    :draw
  end
end

def round_score(elf_move, my_move)
  desired_outcome = round_outcome(my_move)

  score = ROUND_OUTCOME_POINTS[desired_outcome]

  score += ((ELF_MOVES.index(elf_move) + ROUND_OUTCOME_OFFSETS[desired_outcome]) % 3) + 1

  score
end

scores = $input.to_a.map do |line|
  elf_move, my_move = line.split
  round_score(elf_move, my_move)
end

puts scores.sum
