#!/usr/bin/env ruby
require_relative "./launcher"

if ARGV.length > 0
  launcher = Launcher.init(File.open(ARGV[0]).read)
  max_height = launcher.search
  puts "max height: #{max_height}"
end

