require "rspec"
require_relative "./part1"

RSpec.describe "Graph Traversal" do
  it "traverses a graph with just a start and end" do
    expect(CaveTraverser.new([["start", "end"]]).run).to eq(["start,end"])
  end

  it "traverses a straight graph" do
    expect(CaveTraverser.new([["start", "a"], ["a", "end"]]).run).to eq(["start,a,end"])
  end

  it "traverses a graph with two routes" do
    expect(CaveTraverser.new([["start", "a"], ["a", "end"], ["start", "end"]]).run).to match_array(["start,end", "start,a,end"])
  end
end
