require "debug"

class DigitFinder
  def self.count_easy_digits(input)
    finders = build(input)
    finders.each.inject(0) do |sum, finder|
      sum + finder.easy_digits
    end
  end

  def self.sum_digits(input)
    finders = build(input)
    finders.each.inject(0) do |sum, finder|
      sum + finder.sum_digits
    end
  end

  def self.build(input)
    input.split("\n").map do |line|
      new(*line.split(" | "))
    end
  end

  attr_reader :segments, :digits

  def initialize(segments, digits)
    @segments = segments.split(" ").map { |x| x.split("").sort }
    @digits = digits.split(" ").map { |x| x.split("").sort }
    @segment_matchers = [zero, one, two, three, four, five, six, seven, eight, nine]
  end

  def easy_digits
    digits.each.inject(0) do |count, d|
      count + ([one, four, seven, eight].include?(d) ? 1 : 0)
    end
  end

  def sum_digits
    digits.each.inject(0) do |sum, digit|
      sum * 10 + digit_value(digit.join)
    end
  end

  def digit_value(digit)
    digit_to_value_map[digit]
  end

  def digit_to_value_map
    @map ||= {
      zero.join => 0,
      one.join => 1,
      two.join => 2,
      three.join => 3,
      four.join => 4,
      five.join => 5,
      six.join => 6,
      seven.join => 7,
      eight.join => 8,
      nine.join => 9
    }
  end

  def zero
    @zero ||= six_segment_options.detect { |x| ![nine, six].include?(x) }
  end

  def nine
    @nine ||= six_segment_options.detect { |x| !x.include?(e_segment) }
  end

  def six
    @six ||= six_segment_options.detect { |x| !x.include?(c_segment) }
  end

  def e_segment
    @e_segment ||= (two - three)[0]
  end

  def c_segment
    @c_segment ||= (four - five)[0]
  end

  def three
    @three ||= five_segment_options.detect { |x| ![two, five].include?(x) }
  end

  def five
    @five ||= five_segment_options.detect { |x| (four - x).size == 1 && (two - x).size == 2 }
  end

  def two
    @two ||= five_segment_options.detect { |x| (four - x).size == 2 }
  end

  def one
    @one ||= segments.detect { |x| x.size == 2 }
  end

  def four
    @four ||= segments.detect { |x| x.size == 4 }
  end

  def seven
    @seven ||= segments.detect { |x| x.size == 3 }
  end

  def eight
    @eight ||= segments.detect { |x| x.size == 7 }
  end

  def five_segment_options
    @five_segment_options ||= segments.select { |x| x.size == 5 }
  end

  def six_segment_options
    @six_segment_options ||= segments.select { |x| x.size == 6 }
  end
end

if ARGV.length == 1
  result = DigitFinder.sum_digits(File.open(ARGV[0]).read)
  puts result
end
