require 'spec_helper'
require 'validations/spider_params'

describe Validations::SpiderParams do
  describe "rules"

  describe ".call" do
    subject { described_class }

    it "must initialize #{described_class} and call #call" do
      expect(subject.call({})).to be_kind_of(Dry::Validation::Result)
    end
  end
end
