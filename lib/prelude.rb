# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

$input = File.open(ARGV[0]).readlines.map(&:chomp)
