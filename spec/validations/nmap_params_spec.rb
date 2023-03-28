require 'spec_helper'
require 'validations/nmap_params'

describe Validations::NmapParams do
  describe "rules" do
    describe ":ports" do
      context "and when :ports is a valid nmap ports list" do
        it "must return a valid result" do
          result = subject.call({ports: "1,2,3,4-10", targets: ['192.168.1.1']})

          expect(result).to be_success
        end
      end

      context "but when :ports is not a valid nmap ports list" do
        it "must reject invalid nmap ports list" do
          result = subject.call({ports: "1,2,,,,3"})

          expect(result).to be_failure
          expect(result.errors[:ports]).to eq(["invalid nmap port list"])
        end
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
