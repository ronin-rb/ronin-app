require 'spec_helper'
require 'workers/masscan'

describe Workers::Masscan do
  describe "Params" do
    subject { described_class::Params }

    describe ":ips" do
      it "must require an :ips key" do
        result = subject.call({})

        expect(result).to be_failure
        expect(result.errors[:ips]).to eq(["is missing"])
      end
    end
  end
end
