# frozen_string_literal: true

require_relative '../lib/prelude'

$grid = $input.to_a.map { |line| line.chars.map(&:to_i) }

$grid_x = $grid.first.size - 1
$grid_y = $grid.size - 1

def scenic_score(x, y)
  return -1 if x.in?([0, $grid_x]) || y.in?([0, $grid_y])

  tree_height = $grid[x][y]

  score = 1

  puts "Checking #{x}, #{y} (#{tree_height})"

  puts '  Checking left'
  left_score = 0
  (0...x).reverse_each do |sight_line_x|
    sight_line_tree_height = $grid[sight_line_x][y]
    puts "  #{sight_line_x}, #{y} (#{sight_line_tree_height})"
    left_score += 1
    if sight_line_tree_height >= tree_height
      puts "    is >= #{tree_height}"
      break
    end
  end
  puts "  Left score: #{left_score}"
  score *= left_score

  puts '  Checking right'
  right_score = 0
  (x + 1..$grid_x).each do |sight_line_x|
    sight_line_tree_height = $grid[sight_line_x][y]
    puts "  #{sight_line_x}, #{y} (#{sight_line_tree_height})"
    right_score += 1
    if sight_line_tree_height >= tree_height
      puts "    is >= #{tree_height}"
      break
    end
  end
  puts "  Right score: #{right_score}"
  score *= right_score

  puts '  Checking top'
  top_score = 0
  (0...y).reverse_each do |sight_line_y|
    sight_line_tree_height = $grid[x][sight_line_y]
    puts "  #{x}, #{sight_line_y} (#{sight_line_tree_height})"
    top_score += 1
    if sight_line_tree_height >= tree_height
      puts "    is >= #{tree_height}"
      break
    end
  end
  puts "  Top score: #{top_score}"
  score *= top_score

  puts '  Checking bottom'
  bottom_score = 0
  (y + 1..$grid_y).each do |sight_line_y|
    sight_line_tree_height = $grid[x][sight_line_y]
    puts "  #{x}, #{sight_line_y} (#{sight_line_tree_height})"
    bottom_score += 1
    if sight_line_tree_height >= tree_height
      puts "    is >= #{tree_height}"
      break
    end
  end
  puts "  Bottom score: #{bottom_score}"
  score *= bottom_score
  puts "  Score: #{score}"

  score
end

count = 0

$grid.each do |row|
  row.each do |cell|
    print cell
  end
  puts
end
puts

puts((0..$grid_x).flat_map do |x|
  (0..$grid_y).map do |y|
    count += 1
    scenic_score(x, y)
  end
end.max)
