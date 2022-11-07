require_relative "./segment_display"

if ARGV.length == 1
  display = SegmentDisplay.new(%w[g f e d c b a])
  display.display(ARGV[0])
end

