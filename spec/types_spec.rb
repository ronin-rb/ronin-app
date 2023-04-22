require 'spec_helper'
require 'types'

describe Types do
  describe "Types::Args" do
    subject { described_class::Args }

    context "when given a String" do
      context "but it does not contain spaces" do
        let(:string) { "foo" }

        it "must coerce the String into an Array" do
          expect(subject.call(string)).to eq([string])
        end
      end

      context "and it does contain spaces" do
        let(:string) { "foo bar baz" }

        it "must split the String into an Array of Strings" do
          expect(subject.call(string)).to eq(string.split)
        end
      end
    end
  end

  describe "Types::CommaSeparatedList" do
    subject { described_class::CommaSeparatedList }

    context "when given a String" do
      it "must split a ',' separated list" do
        value1 = 'foo'
        value2 = 'bar'
        string = "#{value1},#{value2}"

        expect(subject.call(string)).to eq([value1, value2])
      end

      it "must split a ', ' separated list" do
        value1 = 'foo'
        value2 = 'bar'
        string = "#{value1}, #{value2}"

        expect(subject.call(string)).to eq([value1, value2])
      end

      it "must split a ' ' separated list" do
        value1 = 'foo'
        value2 = 'bar'
        string = "#{value1} #{value2}"

        expect(subject.call(string)).to eq([value1, value2])
      end
    end
  end
end
