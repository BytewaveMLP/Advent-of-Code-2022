# frozen_string_literal: true

require_relative '../lib/prelude'

fs = {}
cwd = '/'

def cmd_cd(cwd, dir)
  ap cwd
  ap dir

  return '/' if dir == '/'

  if dir == '..'
    cwd = cwd.split('/')[0..-2].join('/') + '/'
  else
    cwd = "#{cwd}#{dir}/"
  end

  ap cwd

  cwd
end

doing_ls = false

$input.each do |line|
  if line.starts_with?('$ ')
    if doing_ls
      # backtrack and update all sizes of parent dirs
      path = cwd.split('/')
      path.pop
      while path.any?
        fs[path.join('/') + '/'] ||= 0
        fs[path.join('/') + '/'] += fs[cwd]
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

ap fs
dirs_under_100k = fs.select { |_, v| v <= 100_000 }
ap dirs_under_100k
ap dirs_under_100k.map { |_, v| v }.sum
