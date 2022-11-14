#!/usr/bin/env ruby
require_relative "../day09/grid"
require_relative "./mega_grid"
require_relative "./map_walker"

if ARGV.length > 1
  grid_class = ARGV.length == 1 ? Grid : MegaGrid
  map = grid_class.new(File.open(ARGV[0]).read.split("\n").map { |row| row.split("").map(&:to_i) })
  route = MapWalker.new(map).walk
  score = route.each.inject(0) { |sum, pos| sum + map[pos] }
  score -= map[Position.new(0, 0)]
  puts "The lowest score is: #{score}"
end

