require "rspec"
require_relative "./part2"

describe "filter_common_bits" do
  it "returns numbers with bits that are most common" do
    expect(filter_common_bits(["10", "11", "01"])).to eq("11")
    expect(filter_common_bits(["10", "01"])).to eq("10")
  end
end

describe "filter_uncommon_bits" do
  it "returns numbers with bits that are least common" do
    expect(filter_uncommon_bits(["10", "11", "01"])).to eq("01")
    expect(filter_uncommon_bits(["10", "01"])).to eq("01")
    expect(filter_uncommon_bits(["00", "11", "01"])).to eq("11")
    expect(filter_uncommon_bits(["001", "110", "010"])).to eq("110")
    expect(filter_uncommon_bits(["001", "110", "101"])).to eq("001")
  end
end

describe "to decimal" do
  it "converts a binary string to decimal" do
    expect(to_decimal("10101")).to eq(21)
  end
end

describe "ratings" do
  let(:lines) do
    [
      "00100",
      "11110",
      "10110",
      "10111",
      "10101",
      "01111",
      "00111",
      "11100",
      "10000",
      "11001",
      "00010",
      "01010"
    ]
  end

  it "can find the life support rating" do
    expect(life_support_rating(lines)).to eq(23)
  end

  it "can find the CO2 scrubber rating" do
    expect(co2_scrubber_rating(lines)).to eq(10)
  end

  it "can multiple the results together" do
    expect(run("./day03/test.txt")).to eq(230)
  end
end
