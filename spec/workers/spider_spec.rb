require 'spec_helper'
require './workers/spider'

describe Workers::Spider do
  describe "Params" do
    subject { described_class::Params }

    it "must require a :type key" do
      result = subject.call({target: 'example.com'})

      expect(result).to be_failure
      expect(result.errors[:type]).to eq(["is missing"])
    end

    it "must require a :target key" do
      result = subject.call({type: 'host'})

      expect(result).to be_failure
      expect(result.errors[:target]).to eq(["is missing"])
    end
  end
end
