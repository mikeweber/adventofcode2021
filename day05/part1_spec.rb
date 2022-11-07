require 'rspec'
require_relative './part1'

SAMPLE_TEXT = File.open(File.dirname(__FILE__) + "/test").read

describe "hydrothermal vents" do
  subject(:map) { VentMap.new(SAMPLE_TEXT) }

  it "parses the input" do
    expect(map.width).to eq(9)
    expect(map.height).to eq(9)
  end

  it "tracks the number of spikes" do
    expect(map.spikes).to eq(5)
  end
end
