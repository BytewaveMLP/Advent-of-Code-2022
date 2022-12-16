# frozen_string_literal: true

require_relative '../lib/prelude'

LINE_REGEXP = /Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? (.+)/.freeze
TOTAL_TIME = 30

Valve = Struct.new(:name, :flow_rate, :connections)

valves = {}

$input.each do |line|
  match = LINE_REGEXP.match(line)

  valve_name = match[1]
  flow_rate = match[2].to_i
  connections = match[3].split(', ')

  valves[valve_name] = Valve.new(valve_name, flow_rate, connections)
end

def reachable_from_valve(valves, current_valve)
  reachable = { current_valve => [0, 0] }

  current_valve = valves[current_valve]

  visited = Set.new
  queue = current_valve.connections.dup
  current_cost = 1

  until queue.empty?
    current_cost = queue.shift if queue.first.is_a?(Integer)

    next_valve = queue.shift
    reachable[next_valve] ||= [current_cost, valves[next_valve].flow_rate]
    queue += [(current_cost + 1)] + valves[next_valve].connections

    visited << next_valve
    break if visited.size == valves.size
  end

  reachable
end

reachability_and_flow_map = valves.keys.to_h { |valve| [valve, reachable_from_valve(valves, valve)] }

def move_score(reach_map, valve, time_remaining)
  cost, flow_rate = reach_map[valve]
  time_after_open = time_remaining - cost
  time_after_open.positive? ? (flow_rate * time_after_open) : -1
end

current_valve = 'AA'
time_remaining = TOTAL_TIME
total_flow = 0
visited = Set.new([current_valve])

until time_remaining <= 0 || visited.size == valves.size
  puts("== Minute #{TOTAL_TIME - time_remaining} ==")

  puts("At: #{current_valve}")
  reach_map = reachability_and_flow_map[current_valve]
  puts('Can get to:')
  reach_map.each do |valve, (cost, flow_rate)|
    next if visited.include?(valve)

    puts(" - #{valve} (cost = #{cost}, flow_rate = #{flow_rate}, score = #{move_score(reach_map, valve,
                                                                                      time_remaining)})")
  end

  best_valve = reach_map.keys.max_by do |valve|
    visited.include?(valve) ? -1 : move_score(reach_map, valve, time_remaining)
  end

  score = move_score(reach_map, best_valve, time_remaining)
  break if score <= 0

  visited << best_valve

  cost = reach_map[best_valve][0]
  time_remaining -= cost
  remaining_time = TOTAL_TIME - time_remaining
  new_flow_rate = reach_map[best_valve][1]

  total_flow += (remaining_time - 1) * new_flow_rate

  current_valve = best_valve

  puts("Moved to:        #{current_valve}")
  puts("Move score:      #{score}")
  puts("Visisted valves: #{visited.join(', ')}")
  puts("Time remaining:  #{time_remaining}")
  puts("Flow rate:       #{new_flow_rate}")
  puts("Total flow:      #{total_flow}")
  puts("Cost:            #{cost}")
  puts
end

puts

ap time_remaining
ap total_flow
