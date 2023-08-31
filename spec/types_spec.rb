require 'spec_helper'
require 'ronin/app/types'

describe Ronin::App::Types do
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

  describe "Types::List" do
    subject { described_class::List }

    context "when given a String" do
      let(:value1) { 'foo' }
      let(:value2) { 'bar' }

      it "must split a ',' separated list" do
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

  describe "Types::CommaSeparatedList" do
    subject { described_class::CommaSeparatedList }

    context "when given a String" do
      let(:value1) { 'foo' }
      let(:value2) { 'bar' }
      let(:value3) { 'baz' }

      it "must split a ',' separated list" do
        string = "#{value1},#{value2}"

        expect(subject.call(string)).to eq([value1, value2])
      end

      it "must split a ', ' separated list" do
        string = "#{value1}, #{value2}"

        expect(subject.call(string)).to eq([value1, value2])
      end

      it "must not split a ' ' separated list" do
        string = "#{value1} #{value2}, #{value3}"

        expect(subject.call(string)).to eq(["#{value1} #{value2}", value3])
      end
    end
  end
end
