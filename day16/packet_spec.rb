require "pry-byebug"
require "rspec"
require_relative "./packet"

RSpec.describe "Packet" do
  subject(:packet) { Packet.init(input) }
  let(:input) { "D2FE28" }

  context "when parsing a literal" do
    it "determines the version from the first 3 bits" do
      expect(packet.version).to eq(6)
    end

    it "determines the type from the next 3 bits" do
      expect(packet.type).to eq(4)
    end

    it "has no sub packets" do
      expect(packet.parse.sub_packets.size).to eq(0)
    end

    it "parses the number" do
      expect(packet.parse.value).to eq(2021)
    end

    it "has a type sum of 4" do
      expect(PacketWalker.sum_types(packet)).to eq(4)
    end
  end

  context "when parsing an operator packet" do
    context "and a length type 0" do
      let(:input) { "38006F45291200" }

      it "has a version of 1" do
        expect(packet.version).to eq(1)
      end

      it "has a type of 6" do
        expect(packet.type).to eq(6)
      end

      it "has 2 sub packets" do
        expect(packet.parse.sub_packets.size).to eq(2)
      end

      it "has a sum_types of 14 (6 + 4 + 4)" do
        expect(PacketWalker.sum_types(packet)).to eq(14)
      end
    end

    context "and a length type of 1" do
      let(:input) { "EE00D40C823060" }

      it "has a version of 7" do
        expect(packet.version).to eq(7)
      end

      it "has a type of 3" do
        expect(packet.type).to eq(3)
      end

      it "has 3 sub packets" do
        expect(packet.parse.sub_packets.size).to eq(3)
      end

      it "has a sum_types of 15 (3 + (4 + 4 + 4))" do
        expect(PacketWalker.sum_types(packet)).to eq(15)
      end
    end
  end

  context "when summing types" do
    context "sample1" do
      let(:input) { "8A004A801A8002F478" }

      it "has nested sub packets" do
        expect(packet.version).to eq(4)

        sp1 = packet.parse.sub_packets[0]
        expect(sp1.version).to eq(1)
        expect(sp1.type).to eq(2)

        sp2 = sp1.sub_packets[0]
        expect(sp2.version).to eq(5)
        expect(sp2.type).to eq(2)

        sp3 = sp2.sub_packets[0]
        expect(sp3.version).to eq(6)
        expect(sp3.type).to eq(4)
        expect(sp3.value).to eq(15)
      end

      it "has a version sum of 16" do
        expect(PacketWalker.sum_versions(packet.parse)).to eq(16)
      end
    end

    context "sample2" do
      let(:input) { "620080001611562C8802118E34" }

      it "has a version sum of 12" do
        expect(PacketWalker.sum_versions(packet.parse)).to eq(12)
      end
    end

    context "sample3" do
      let(:input) { "C0015000016115A2E0802F182340" }

      it "has a version sum of 23" do
        expect(PacketWalker.sum_versions(packet.parse)).to eq(23)
      end
    end

    context "sample4" do
      let(:input) { "A0016C880162017C3686B18A3D4780" }

      it "has a version sum of 31" do
        expect(PacketWalker.sum_versions(packet.parse)).to eq(31)
      end
    end
  end

  context "when using operations" do
    it "returns a sum" do
      expect(Packet.init("C200B40A82").parse.value).to eq(3)
    end

    it "returns a product" do
      expect(Packet.init("04005AC33890").parse.value).to eq(54)
    end

    it "returns the minimum" do
      expect(Packet.init("880086C3E88112").parse.value).to eq(7)
    end

    it "returns the maximum" do
      expect(Packet.init("CE00C43D881120").parse.value).to eq(9)
    end

    it "returns 1 when a value is less than" do
      expect(Packet.init("D8005AC2A8F0").parse.value).to eq(1)
    end

    it "returns 0 when a value is not greater than" do
      expect(Packet.init("F600BC2D8F").parse.value).to eq(0)
    end

    it "returns 0 when two values are not equal" do
      expect(Packet.init("9C005AC2F8F0").parse.value).to eq(0)
    end

    it "can compare multiple sub operands" do
      expect(Packet.init("9C0141080250320F1802104A08").parse.value).to eq(1)
    end
  end
end
