class Parser
  def self.score_corrupted(lines)
    lines.each.inject(0) do |sum, line|
      type, score = line_score(line)
      type == :corrupt ? sum + score : sum
    end
  end

  def self.score_autocomplete(lines)
    scores = lines.each.with_object([]) do |line, scores|
      type, score = line_score(line)
      scores << score if type == :autocomplete
    end

    scores.sort[scores.size / 2]
  end

  def self.score_map
    @score_map ||= {
      "(" => 1,
      "[" => 2,
      "{" => 3,
      "<" => 4
    }
  end

  def self.line_score(line)
    stack = []

    line.split("").each do |ch|
      case ch
      when "{", "(", "[", "<"
        stack << ch
      when ")"
        return [:corrupt, 3] unless stack.pop == "("
      when "]"
        return [:corrupt, 57] unless stack.pop == "["
      when "}"
        return [:corrupt, 1197] unless stack.pop == "{"
      when ">"
        return [:corrupt, 25137] unless stack.pop == "<"
      else
        raise "What is this?!? #{ch}"
      end
    end

    score = stack.reverse.inject(0) do |sum, ch|
      sum * 5 + score_map.fetch(ch)
    end

    return [:autocomplete, score]
  end
end

if ARGV.length == 1
  score = Parser.score_corrupted(File.open(ARGV[0]).read.split("\n"))
  puts "Score is #{score}"
end

if ARGV.length == 2
  score = Parser.score_autocomplete(File.open(ARGV[0]).read.split("\n"))
  puts "Middle score is #{score}"
end
