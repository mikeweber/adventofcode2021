class PolymerBuilder
  attr_reader :polymer, :rules

  def self.init(input)
    lines = input.split("\n")
    initial_template = lines.shift.split("")
    lines.shift
    new(initial_template, lines)
  end

  def initialize(template, rules)
    @polymer = Polymer.new(template)
    @rules = rules.each.with_object({}) do |rule, h|
      pair, new_el = rule.split(" -> ")
      h[pair] = new_el
    end
  end

  def grow!
    polymer.each do |el|
      next unless new_el = rules[el.pair_name]

      el << new_el
    end
  end

  def limits
    counts = polymer.each.with_object(Hash.new { |h, k| h[k] = 0 }) do |el, counts|
      counts[el.name] += 1
    end
    min = { letter: "", count: nil }
    max = { letter: "", count: 0 }
    counts.each do |letter, count|
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

  def to_s
    polymer.to_s
  end
end

class Polymer
  attr_reader :head

  def initialize(template)
    @head = Element.new(template.shift)
    cur = @head
    while el = template.shift
      cur << el
      cur = cur.tail
    end
  end

  def to_s
    each.inject("") do |str, el|
      str + el.name
    end
  end

  def each(&block)
    return to_enum(:each) unless block_given?

    curr_node = head
    while curr_node
      orig_tail = curr_node.tail
      yield curr_node
      curr_node = orig_tail
    end
  end
end

class Element
  attr_reader :name, :tail

  def initialize(name, tail = nil)
    @name = name
    @tail = tail
  end

  def pair_name
    return name if tail.nil?

    name + tail.name
  end

  def <<(name)
    return @tail = nil if name.nil?

    @tail = self.class.new(name, @tail)
  end

  def inspect
    "<Element #{name}#{" (no tail)" if tail.nil?}>"
  end
end
