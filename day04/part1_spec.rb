require "rspec"
require_relative "./part1"

SAMPLE_TEXT = %{7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7}

describe "best_bingo_card" do
  subject(:game) { BingoGame.new(SAMPLE_TEXT) }
  let(:expected_draws) { [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1] }

  it "parses the list of drawn numbers" do
    expect(game.draws).to eq(expected_draws)
  end

  it "parses the cards" do
    expect(game.cards.size).to eq(3)
  end

  context "BingoCard" do
    subject(:card) { BingoGame.new(SAMPLE_TEXT).cards[0] }

    it "stores the 25 numbers" do
      expect(card.location_of(22)).not_to be_nil
      expect(card.location_of(25)).to be_nil
    end

    it "marks matching numbers" do
      expect { card.mark(22) }.to change { card.marks.size }.by(1)
      expect { card.mark(25) }.not_to change { card.marks.size }
    end

    it "can determine when a row has been filled" do
      card.mark(22)
      card.mark(13)
      card.mark(17)
      card.mark(0)
      expect(card.marks.size).to eq(4)
      expect { card.mark(11) }.to change { card.bingo? }.from(false).to(true)
    end

    it "can determine when another row has been filled" do
      card.mark(5)
      card.mark(3)
      card.mark(6)
      card.mark(10)
      expect(card.marks.size).to eq(4)
      expect { card.mark(18) }.to change { card.bingo? }.from(false).to(true)
    end

    it "can determine when a column has been filled" do
      card.mark(14)
      card.mark(23)
      card.mark(17)
      card.mark(3)
      expect(card.marks.size).to eq(4)
      expect { card.mark(20) }.to change { card.bingo? }.from(false).to(true)
    end

    it "reduces the board sum after each mark" do
      expect(card.sum).to eq(300)
      card.mark(14)
      expect(card.sum).to eq(286)
      card.mark(23)
      expect(card.sum).to eq(263)
      card.mark(17)
      expect(card.sum).to eq(246)
      card.mark(3)
      expect(card.sum).to eq(243)
    end
  end
end
