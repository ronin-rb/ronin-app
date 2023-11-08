require 'spec_helper'
require './workers/nmap'

describe Workers::Nmap do
  describe "Params" do
    subject { described_class::Params }

    describe ":url" do
      it "must require :url key" do
        result = subject.call({})

        expect(result).to be_failure
        expect(result.errors[:targets]).to eq(["is missing"])
      end
    end
  end
end
