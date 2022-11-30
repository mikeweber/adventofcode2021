#!/usr/bin/env ruby
require_relative "./packet"

if ARGV.length > 0
  packet = Packet.init(File.open(ARGV[0]).read).parse
  puts "The transmission value is: #{packet.value}"
end

