class PolymerBuilder
  attr_reader :pairs, :rules

  def self.init(input)
    lines = input.split("\n")
    initial_template = lines.shift.split("")
    lines.shift
    new(initial_template, lines)
  end

  def initialize(template, rules)
    @last_el = template[-1]
    @pairs = template[0..-2].each.with_index.with_object(Hash.new { |h, k| h[k] = 0 }) do |(el, i), pairs|
      pairs[PolymerPair.new(el, template[i + 1])] += 1
    end
    @rules = rules.each.with_object({}) do |rule, h|
      pair, new_el = rule.split(" -> ")
      h[PolymerPair.new(*pair.split(""))] = new_el
    end
  end

  def grow!
    new_pairs = pairs.dup
    rules.each do |rule, result|
      new_pairs[PolymerPair.new(rule.part1, result)] += pairs[rule]
      new_pairs[PolymerPair.new(result, rule.part2)] += pairs[rule]
      new_pairs[rule] -= pairs[rule]
    end
    @pairs = new_pairs
  end

  def limits
    min = { letter: "", count: nil }
    max = { letter: "", count: 0 }
    letter_counts.each do |letter, count|
      if min[:count].nil? || count < min[:count]
        min[:letter] = letter
        min[:count] = count
      end
      if max[:count] < count
        max[:letter] = letter
        max[:count] = count
      end
    end
    [min, max]
  end

  def size
    letter_counts.values.inject(:+)
  end

  private

  def letter_counts
    counts = pairs.each.with_object(Hash.new { |h, k| h[k] = 0 }) do |(pair, count), counts|
      counts[pair.part1] += count
    end
    counts[@last_el] += 1
    counts
  end
end

class PolymerPair
  attr_reader :pair, :part1, :part2

  def initialize(part1, part2)
    @part1 = part1
    @part2 = part2
    @pair = part1 + part2
  end

  def inspect
    to_s
  end

  def to_s
    pair
  end

  def ==(other)
    pair == other.pair
  end

  alias eql? ==

  def hash
    pair.hash
  end
end
