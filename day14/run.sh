#!/usr/bin/env ruby
require_relative "./polymer_builder"

if ARGV.length > 0
  builder = PolymerBuilder.init(File.open(ARGV[0]).read)
  (ARGV[1] || 1).to_i.times do |i|
    builder.grow!
    puts "Grew #{i + 1} times"
  end
  puts "polymer size: #{builder.size}"
  min, max = builder.limits
  puts "Max element:  (#{max[:letter]}, #{max[:count]})"
  puts "Min element:  (#{min[:letter]}, #{min[:count]})"
  puts "Score: #{max[:count] - min[:count]}"
end
