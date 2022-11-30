#!/usr/bin/env ruby
require_relative "./packet"

if ARGV.length > 0
  packet = Packet.init(File.open(ARGV[0]).read)
  result = PacketWalker.sum_versions(packet.parse)
  puts "The sum of types is: #{result}"
end

# 353 too low
