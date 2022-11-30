require "pry-byebug"
class Packet
  attr_reader :signal, :version, :type, :sub_packets

  def self.init(input)
    new(HexIterator.new(input))
  end

  def self.as_decimal(array)
    array.compact.reverse.each.with_index.inject(0) { |s, (el, i)| s + (el == 0 ? 0 : 2 ** i) }
  end

  def initialize(signal)
    @signal = signal

    @version = as_decimal(signal.take(3))
    @type = as_decimal(signal.take(3))
  end

  def parse
    case type
    when 4
      LiteralPacket.new(signal, type, version).parse
    else
      @sub_packets = parse_sub_packets
      self
    end
  end

  def value
  end

  def as_decimal(value)
    self.class.as_decimal(value)
  end

  private

  def parse_sub_packets
    return [] unless (length_type_id = signal.next)

    case length_type_id
    when 0
      total_length = as_decimal(signal.take(15))
      sub_packet_iter = BitIterator.new(signal.take(total_length))
      sub_packets = []
      while !sub_packet_iter.empty?
        sub_packets << self.class.new(sub_packet_iter).parse
      end
      sub_packets
    when 1
      number_sub_packets = as_decimal(signal.take(11))
      number_sub_packets.times.map do
        self.class.new(signal).parse
      end
    else
      []
    end
  end
end

class LiteralPacket < Packet
  attr_reader :value

  def initialize(signal, type, version)
    @signal = signal
    @type = type
    @version = version
  end

  def parse
    continue_bit = 1
    bits = []
    taken = 1
    while continue_bit == 1
      break unless continue_bit = signal.next
      bits += signal.take(4)
      taken += 4
    end
    @value = as_decimal(bits)
    self
  end

  def sub_packets
    []
  end
end

class PacketWalker
  def self.sum_types(packet)
    packet.parse.sub_packets.each.inject(packet.type) do |sum, sub_packet|
      sum + sum_types(sub_packet)
    end
  end

  def self.sum_versions(packet)
    packet.sub_packets.each.inject(packet.version) do |sum, sub_packet|
      sum + sum_versions(sub_packet)
    end
  end
end

class HexIterator
  attr_reader :cur_char, :length

  def initialize(input)
    @length = input.length
    @hex_chars = input.split("")
    @cur_hex_idx = -1
    @cur_bit_idx = 3
  end

  def each
    return enum_for(:each) unless block_given?

    while el = next_el
      yield el
    end
  end

  def take(n)
    n.times.map { next_el }
  end

  def next
    next_el
  end

  def cur_bit
    cur_bits[cur_bit_idx]
  end

  def to_s
    s = hex_chars[[0, cur_hex_idx].max..-1] || []
    "<Hex idx=#{cur_hex_idx}/#{length}> #{s.join("")}"
  end

  private

  attr_reader :hex_chars
  attr_accessor :cur_hex_idx, :cur_bit_idx, :cur_bits
  attr_writer :cur_char

  def next_el
    if cur_bit_idx == 3
      return unless next_hex
      self.cur_bit_idx = 0
    else
      self.cur_bit_idx += 1
    end

    cur_bit
  end

  def next_hex
    self.cur_hex_idx += 1
    return if cur_hex_idx >= length

    self.cur_char = hex_chars[cur_hex_idx]
    x = cur_char.hex.digits(2).reverse
    self.cur_bits = [*(4 - x.length).times.map { 0 }, *x]
  end
end

class BitIterator
  def initialize(bits)
    @bits = bits
    @cur_bit_idx = -1
  end

  def each
    return enum_for(:each) unless block_given?

    while el = next_el
      yield el
    end
  end

  def take(n)
    n.times.map { next_el }.compact
  end

  def next
    next_el
  end

  def empty?
    cur_bit_idx >= bits.length - 1
  end

  def to_s
    "<Bits idx=#{cur_bit_idx}/#{bits.length}> #{bits[[cur_bit_idx, 0].max..-1].join("")}"
  end

  private

  attr_reader :bits
  attr_accessor :cur_bit_idx

  def next_el
    self.cur_bit_idx += 1

    bits[cur_bit_idx]
  end
end
