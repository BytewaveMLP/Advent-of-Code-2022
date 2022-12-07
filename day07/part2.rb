# frozen_string_literal: true

require_relative '../lib/prelude'

FS_SIZE = 70_000_000
FREE_SPACE_REQUIRED = 30_000_000

fs = { '/' => 0 }
cwd = '/'

def cmd_cd(cwd, dir)
  return '/' if dir == '/'

  if dir == '..'
    cwd = cwd.split('/')[0..-2].join('/') + '/'
  else
    cwd = "#{cwd}#{dir}/"
  end

  cwd
end

doing_ls = false

$input.each do |line|
  if line.starts_with?('$ ')
    if doing_ls
      # backtrack and update all sizes of parent dirs
      path = cwd.split('/')

      path.pop

      ap cwd
      ap fs[cwd]
      ap path

      while path.any?
        puts 'UPDATING'
        fs[path.join('/') + '/'] ||= 0
        fs[path.join('/') + '/'] += fs[cwd]
        ap path.join('/') + '/'
        ap fs[path.join('/') + '/']

        path.pop
      end

      doing_ls = false
    end
    command = line[2..-1].split
    if command[0] == 'cd'
      cwd = cmd_cd(cwd, command[1])
    elsif command[0] == 'ls'
      # init size
      fs[cwd] ||= 0
      doing_ls = true
    end
  else
    # file list
    file_info = line.split
    next if file_info[0] == 'dir'

    file_size = file_info[0].to_i

    fs[cwd] += file_size
  end
end

if doing_ls
  # backtrack and update all sizes of parent dirs
  path = cwd.split('/')

  path.pop

  ap cwd
  ap fs[cwd]
  ap path

  while path.any?
    puts 'UPDATING'
    fs[path.join('/') + '/'] ||= 0
    fs[path.join('/') + '/'] += fs[cwd]
    ap path.join('/') + '/'
    ap fs[path.join('/') + '/']

    path.pop
  end

  doing_ls = false
end

AVAILABLE_SPACE = FS_SIZE - fs['/']

puts 'AVAILABLE_SPACE'
ap AVAILABLE_SPACE

NEEDED_SPACE = FREE_SPACE_REQUIRED - AVAILABLE_SPACE

ap fs
dirs_free = fs.select { |_, v| v >= NEEDED_SPACE }
ap dirs_free
ap dirs_free.map { |_, v| v }.min
