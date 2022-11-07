require "rspec"
require_relative "./part1"

LARGE_EXAMPLE = %[
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
].strip

LARGEST_EXAMPLE = %[
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
].strip

RSpec.describe "Graph Traversal" do
  context "when limit is 1" do
    it "traverses a graph with just a start and end" do
      expect(CaveTraverser.new([["start", "end"]]).run).to eq(["start,end"])
    end

    it "traverses a straight graph" do
      expect(CaveTraverser.new([["start", "a"], ["a", "end"]]).run).to eq(["start,a,end"])
    end

    it "traverses a graph with two routes" do
      expect(CaveTraverser.new([["start", "a"], ["a", "end"], ["start", "end"]]).run).to match_array(["start,end", "start,a,end"])
    end

    it "excludes routes use small caves more than once" do
      expect(CaveTraverser.new([["start", "b"], ["b", "d"], ["b", "end"]]).run).to match_array(["start,b,end"])
    end

    it "includes routes that use large caves more than once" do
      edges = [
        ["start", "A"],
        ["A", "b"],
        ["start", "b"],
        ["b", "d"],
        ["b", "end"]
      ]
      expect(CaveTraverser.new(edges).run).to match_array(["start,A,b,end", "start,b,end"])
    end

    it "includes detours from large cages" do
      edges = [
        ["start", "A"],
        ["A", "b"],
        ["A", "c"],
        ["A", "end"]
      ]
      expected_routes = [
        "start,A,end",
        "start,A,b,A,c,A,end",
        "start,A,b,A,end",
        "start,A,c,A,b,A,end",
        "start,A,c,A,end"
      ]
      expect(CaveTraverser.new(edges).run).to match_array(expected_routes)
    end

    it "works with the small example" do
      edges = [
        ["start", "A"],
        ["start", "b"],
        ["A", "c"],
        ["A", "b"],
        ["b", "d"],
        ["A", "end"],
        ["b", "end"]
      ]
      expect(CaveTraverser.new(edges).run).to match_array([
        "start,A,b,A,c,A,end",
        "start,A,b,A,end",
        "start,A,b,end",
        "start,A,c,A,b,A,end",
        "start,A,c,A,b,end",
        "start,A,c,A,end",
        "start,A,end",
        "start,b,A,c,A,end",
        "start,b,A,end",
        "start,b,end"
      ])
    end

    it "works with a larger example" do
      expect(CaveTraverser.init(LARGE_EXAMPLE).run.size).to eq(19)
    end

    it "works with the largest example" do
      expect(CaveTraverser.init(LARGEST_EXAMPLE).run.size).to eq(226)
    end
  end

  context "when wait limit is 2" do
    it "includes side routes twice" do
      edges = [
        ["start", "A"],
        ["A", "b"],
        ["A", "end"]
      ]

      expected_paths = [
        "start,A,end",
        "start,A,b,A,end",
        "start,A,b,A,b,end"
      ]

      expect(CaveTraverser.new(edges).run(2)).to match_array(expected_paths)
    end

    it "works with the small example" do
      edges = [
        ["start", "A"],
        ["start", "b"],
        ["A", "c"],
        ["A", "b"],
        ["b", "d"],
        ["A", "end"],
        ["b", "end"]
      ]
      expect(CaveTraverser.new(edges).run(2).size).to eq(36)
    end

    it "works with a larger example" do
      expect(CaveTraverser.init(LARGE_EXAMPLE).run(2).size).to eq(103)
    end

    it "works with the largest example" do
      expect(CaveTraverser.init(LARGEST_EXAMPLE).run(2).size).to eq(3509)
    end
  end
end
