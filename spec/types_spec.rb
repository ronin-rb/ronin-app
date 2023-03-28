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
end
