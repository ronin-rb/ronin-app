require 'spec_helper'
require 'ronin/app/validations/vulns_params'

describe Ronin::App::Validations::VulnsParams do
  describe "rules" do
    describe ":url" do
      it "must require a :url key" do
        result = subject.call({})

        expect(result).to be_failure
        expect(result.errors[:url]).to eq(["is missing"])
      end
    end
  end

  describe ".call" do
    subject { described_class }

    it "must initialize #{described_class} and call #call" do
      expect(subject.call({})).to be_kind_of(Dry::Validation::Result)
    end
  end
end
