require 'spec_helper'
require 'types/spider'

describe Types::Spider do
  describe "Types::Spider::HostList" do
    subject { Types::Spider::HostList }

    it "must use Types::CommaSeparatedList" do
      expect(subject).to be(Types::CommaSeparatedList)
    end
  end

  describe "Types::Spider::PortList" do
    subject { Types::Spider::PortList }

    context "when given a String" do
      let(:value1) { 42 }
      let(:value2) { 7  }

      it "must split a ',' separated list into an Array of Integers" do
        string = "#{value1},#{value2}"

        expect(subject.call(string)).to eq([value1, value2])
      end

      it "must split a ', ' separated list" do
        string = "#{value1}, #{value2}"

        expect(subject.call(string)).to eq([value1, value2])
      end

      it "must split a ' ' separated list" do
        string = "#{value1} #{value2}"

        expect(subject.call(string)).to eq([value1, value2])
      end
    end
  end

  describe "Types::Spider::URLList" do
    subject { Types::Spider::URLList }

    it "must use Types::CommaSeparatedList" do
      expect(subject).to be(Types::CommaSeparatedList)
    end
  end

  describe "Types::Spider::ExtList" do
    subject { Types::Spider::ExtList }

    it "must use Types::CommaSeparatedList" do
      expect(subject).to be(Types::CommaSeparatedList)
    end
  end
end
