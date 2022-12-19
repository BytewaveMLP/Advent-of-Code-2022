# frozen_string_literal: true

require_relative '../lib/prelude'

LINE_REGEXP = /Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian.$/.freeze

TICKS_PER_BLUEPRINT = 24

blueprints = []

$input.each do |line|
  match = line.match(LINE_REGEXP)
  raise "Match against #{line} failed" unless match

  ore_cost = match[1].to_i
  clay_cost = match[2].to_i
  obsidian_cost_ore = match[3].to_i
  obsidian_cost_clay = match[4].to_i
  geode_cost_ore = match[5].to_i
  geode_cost_obsidian = match[6].to_i

  blueprints << {
    ore: {
      ore: ore_cost
    },
    clay: {
      ore: clay_cost
    },
    obsidian: {
      ore: obsidian_cost_ore,
      clay: obsidian_cost_clay
    },
    geode: {
      ore: geode_cost_ore,
      obsidian: geode_cost_obsidian
    }
  }
end

def craftable?(blueprint, resources, robot_type)
  blueprint[robot_type].each do |resource, cost|
    return false if resources[resource] < cost
  end

  true
end

def craft(blueprint, resources, robots, robot_type)
  used_resources = {}
  blueprint[robot_type].each do |resource, cost|
    resources[resource] -= cost
    used_resources[resource] = cost
  end
  robots[robot_type] += 1
  used_resources
end

def simulate(tick_number, blueprints, resources, robots)
  return resources[:geode] if tick_number.zero?

  robots.each_pair do |robot_type, num_robots|
    resources[robot_type] += num_robots
  end

  qualities_if_resources_crafted = []
  robots.each_key do |robot_type|
    next unless craftable?(blueprints, resources, robot_type)

    used_resources = craft(blueprints, resources, robots, robot_type)
    quality_if_crafted = simulate(tick_number - 1, blueprints, resources, robots)

    used_resources.each_pair do |resource, cost|
      resources[resource] += cost
    end
    robots[robot_type] -= 1

    qualities_if_resources_crafted << quality_if_crafted
  end

  # simulate crafting nothing
  [*qualities_if_resources_crafted, simulate(tick_number - 1, blueprints, resources, robots)].max
end

progress_bar = ProgressBar.create(
  title: 'Simulating',
  total: blueprints.size,
  format: '%t: |%W| %c/%C %e'
)

quality_scores = blueprints.each_with_index.map do |blueprint, index|
  resources = {
    ore: 0,
    clay: 0,
    obsidian: 0,
    geode: 0
  }
  robots = {
    ore: 1,
    clay: 0,
    obsidian: 0,
    geode: 0
  }

  crafted_geodes = simulate(TICKS_PER_BLUEPRINT, blueprint, resources, robots)

  puts("Blueprint #{index + 1}: #{crafted_geodes} geodes")

  progress_bar.increment

  crafted_geodes * (index + 1)
end

puts quality_scores.sum
