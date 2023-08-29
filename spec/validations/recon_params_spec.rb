require 'spec_helper'
require 'ronin/app/validations/recon_params'

describe Ronin::App::Validations::ReconParams do
  describe "rules" do
    describe ":scope" do
      it "must require a :scope key" do
        result = subject.call({})

        expect(result).to be_failure
        expect(result.errors[:scope]).to eq(["is missing"])
      end

      it "must require a non-empty value for :scope" do
        result = subject.call({scope: ""})

        expect(result).to be_failure
        expect(result.errors[:scope]).to eq(["must be filled"])
      end

      it "must accept IP range(s)" do
        result = subject.call({scope: "192.168.1.1/24 10.0.0.1/30"})

        expect(result).to be_success
      end

      it "must accept IP(s)" do
        result = subject.call({scope: "192.168.1.1 10.0.0.1"})

        expect(result).to be_success
      end

      it "must accept website base URL(s)" do
        result = subject.call({scope: "https://example.com http://github.com/"})

        expect(result).to be_success
      end

      it "must accept wildcard domain(s)" do
        result = subject.call({scope: "*.example.com *.foo.github.com"})

        expect(result).to be_success
      end

      it "must accept hostnames(s)" do
        result = subject.call({scope: "www.example.com foo.bar.github.com"})

        expect(result).to be_success
      end

      it "must accept domains(s)" do
        result = subject.call({scope: "example.com github.com"})

        expect(result).to be_success
      end

      it "must must all other unrecognized Strings" do
        bad_values = %w[foo 1234]

        result = subject.call({scope: bad_values.join(' ')})

        expect(result).to be_failure
        expect(result.errors[:scope]).to eq(["value must be an IP address, CIDR IP range, domain, sub-domain, wildcard hostname, or website base URL: #{bad_values.join(', ')}"])
      end
    end

    describe ":max_depth" do
      context "when :max_depth is set" do
        it "must be an Integer" do
          result = subject.call({max_depth: "foo"})

          expect(result).to be_failure
          expect(result.errors[:max_depth]).to eq(["must be an integer"])
        end

        it "must be greater than 1" do
          result = subject.call({max_depth: "0"})

          expect(result).to be_failure
          expect(result.errors[:max_depth]).to eq(["max_depth must be greater than 1"])
        end

        it "must not accept negative values" do
          result = subject.call({max_depth: "-1"})

          expect(result).to be_failure
          expect(result.errors[:max_depth]).to eq(["max_depth must be greater than 1"])
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
