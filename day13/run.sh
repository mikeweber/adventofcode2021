#!/usr/bin/env ruby
require_relative "./part1"

if ARGV.length > 0
  paper = Paper.init(File.open(ARGV[0]).read)
  (ARGV[1] || paper.folds.size).to_i.times do
    paper.fold!
  end
  puts paper.inspect
  puts "Mark count is #{paper.count}"
end
