class BingoGame
  attr_reader :draws, :cards

  def initialize(input)
    groups = input.split("\n\n")
    @draws = groups[0].split(",").map(&:to_i)
    @cards = groups[1..-1].each.with_object([]) do |card_input, cards|
      cards << BingoCard.new(card_input)
    end
  end
end

class BingoCard
  attr_reader :spots, :marks

  def initialize(input)
    @spots = input.split("\n").map { |line| line.strip.split(/ +/).map(&:to_i) }.flatten
    @marks = []
  end

  def mark(draw)
    return unless spot = location_of(draw)

    marks << spot
  end

  def location_of(draw)
    spots.index(draw)
  end

  def bingo?
    row_bingo? || col_bingo?
  end

  private

  def row_bingo?
    (0..4).any? do |row|
      (0..4).all? do |col|
        marks.include?(row * 5 + col)
      end
    end
  end

  def col_bingo?
    (0..4).any? do |col|
      (0..4).all? do |row|
        marks.include?(row * 5 + col)
      end
    end
  end
end
