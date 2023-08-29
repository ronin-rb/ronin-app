require 'spec_helper'
require 'ronin/app/types/spider'

describe Ronin::App::Types::Spider do
  describe "Ronin::App::Types::Spider::HostList" do
    subject { Ronin::App::Types::Spider::HostList }

    it "must use Types::CommaSeparatedList" do
      expect(subject).to be(Ronin::App::Types::CommaSeparatedList)
    end
  end

  describe "Ronin::App::Types::Spider::PortList" do
    subject { Ronin::App::Types::Spider::PortList }

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

  describe "Ronin::App::Types::Spider::URLList" do
    subject { Ronin::App::Types::Spider::URLList }

    it "must use Types::CommaSeparatedList" do
      expect(subject).to be(Ronin::App::Types::CommaSeparatedList)
    end
  end

  describe "Ronin::App::Types::Spider::ExtList" do
    subject { Ronin::App::Types::Spider::ExtList }

    it "must use Types::CommaSeparatedList" do
      expect(subject).to be(Ronin::App::Types::CommaSeparatedList)
    end
  end
end
