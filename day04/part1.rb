class BingoGame
  attr_reader :draws, :cards

  def initialize(input)
    groups = input.split("\n\n")
    @draws = groups[0].split(",").map(&:to_i)
    @cards = groups[1..-1].each.with_object([]) do |card_input, cards|
      cards << BingoCard.new(card_input)
    end
  end

  def run
    winner = nil
    last_draw = nil
    while winner.nil?
      last_draw = draws.shift
      cards.each do |card|
        card.mark(last_draw)
        if card.bingo?
          winner = card
        end
      end
    end

    winner.sum * last_draw
  end

  def find_loser
    loser = nil
    last_draw = nil

    while loser.nil?
      draw = draws.shift
      cards.each do |card|
        card.mark(draw)
      end
      cards.reject! { |c| c.bingo? }

      loser = cards[0] if cards.size == 1
    end
    while !loser.bingo?
      loser.mark(last_draw = draws.shift)
    end

    loser.sum * last_draw
  end
end

class BingoCard
  attr_reader :spots, :marks, :sum

  def initialize(input)
    @spots = input.split("\n").map { |line| line.strip.split(/ +/).map(&:to_i) }.flatten
    @marks = []
    @sum = spots.each.inject(0) { |sum, spot| sum + spot }
  end

  def mark(draw)
    return unless spot = location_of(draw)

    @sum -= draw
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

if ARGV.length == 1
  input = File.open(ARGV[0]).read
  game = BingoGame.new(input)
  winning_score = game.find_loser
  puts "Losing board has score of #{winning_score}"
end
