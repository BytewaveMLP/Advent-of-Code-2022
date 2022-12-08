# frozen_string_literal: true

require_relative '../lib/prelude'

$grid = $input.to_a.map { |line| line.chars.map(&:to_i) }

$grid_x = $grid.first.size - 1
$grid_y = $grid.size - 1

ap $grid

def visible_from_outside?(x, y)
  return true if x.in?([0, $grid_x]) || y.in?([0, $grid_y])

  tree_height = $grid[x][y]

  puts "Checking #{x}, #{y} (#{tree_height})"

  visible_from_left = true
  visible_from_right = true
  visible_from_top = true

  puts '  Checking left'
  (0...x).each do |sight_line_x|
    puts "  #{sight_line_x}, #{y}"
    if $grid[sight_line_x][y] >= tree_height
      puts "    is >= #{tree_height} (#{$grid[sight_line_x][y]})"
      visible_from_left = false
      break
    end
  end

  return true if visible_from_left

  puts '  Checking right'
  (x + 1..$grid_x).each do |sight_line_x|
    puts "  #{sight_line_x}, #{y}"
    if $grid[sight_line_x][y] >= tree_height
      puts "    is >= #{tree_height} (#{$grid[sight_line_x][y]})"
      visible_from_right = false
      break
    end
  end

  return true if visible_from_right

  puts '  Checking top'
  (0...y).each do |sight_line_y|
    puts "  #{x}, #{sight_line_y}"
    if $grid[x][sight_line_y] >= tree_height
      puts "    is >= #{tree_height} (#{$grid[x][sight_line_y]})"
      visible_from_top = false
      break
    end
  end

  return true if visible_from_top

  puts '  Checking bottom'
  (y + 1..$grid_y).each do |sight_line_y|
    puts "  #{x}, #{sight_line_y}"
    if $grid[x][sight_line_y] >= tree_height
      puts "    is >= #{tree_height} (#{$grid[x][sight_line_y]})"
      return false
    end
  end

  true
end

count = 0

(0..$grid_x).each do |x|
  (0..$grid_y).each do |y|
    if visible_from_outside?(x, y)
      count += 1
      # print $grid[x][y]
    else
      # print '.'
    end
  end

  # puts
end

puts count
