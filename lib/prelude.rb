# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'English'

Bundler.require(:default)

require 'active_support/all'

if ARGV[0].blank?
  puts "usage: #{File.basename($PROGRAM_NAME)} <input>"
  exit 1
end

$input = File.open(ARGV[0]).readlines(chomp: true)
