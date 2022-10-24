def run(filename)
  lines = File.open(filename).readlines.map { |s| s.strip }
  lsr = life_support_rating(lines)
  csr = co2_scrubber_rating(lines)
  lsr * csr
end

def life_support_rating(lines)
  to_decimal(filter_common_bits(lines))
end

def co2_scrubber_rating(lines)
  to_decimal(filter_uncommon_bits(lines))
end

def filter_common_bits(lines, position = 0)
  return lines[0] if lines.length <= 1
  raise lines.inspect if position > lines[0].length

  ones = []
  zeros = []
  lines.each do |line|
    (line[position] == "1" ? ones : zeros) << line
  end
  filter_common_bits(ones.length >= zeros.length ? ones : zeros, position + 1)
end

def filter_uncommon_bits(lines, position = 0)
  return lines[0] if lines.length <= 1
  raise lines.inspect if position > lines[0].length

  ones = []
  zeros = []
  lines.each do |line|
    (line[position] == "1" ? ones : zeros) << line
  end
  filter_uncommon_bits(zeros.length <= ones.length ? zeros : ones, position + 1)
end

def to_decimal(str)
  str.chars.reverse.each.with_index.inject(0) { |sum, (ch, i)| sum + (ch == '1' ? 2 ** i : 0) }
end

if ARGV.length > 0
  puts run(ARGV[0])
end

# 27288436 <- too high
