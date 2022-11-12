#!/usr/bin/env ruby
require_relative "./polymer_builder"

if ARGV.length > 0
  builder = PolymerBuilder.init(File.open(ARGV[0]).read)
  puts "init:         #{builder.to_s}"
  (ARGV[1] || 1).to_i.times do |i|
    builder.grow!
    puts "Grew #{i + 1} times"
  end
  if ARGV[2]
    puts "polymer size: #{builder.to_s.size}"
  else
    puts "after growth: #{builder.to_s}"
  end
  min, max = builder.limits
  puts "Max element:  (#{max[:letter]}, #{max[:count]})"
  puts "Min element:  (#{min[:letter]}, #{min[:count]})"
  puts "Score: #{max[:count] - min[:count]}"
end
