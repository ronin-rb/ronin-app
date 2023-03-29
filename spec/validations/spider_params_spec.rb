require 'spec_helper'
require 'validations/spider_params'

describe Validations::SpiderParams do
  describe "rules" do
    context "when type is 'host'" do
      context "and 'target' is a valid host name" do
        let(:params) do
          {'type' => 'host', 'target' => 'localhost'}
        end

        it "must return success" do
          expect(subject.call(params)).to be_success
        end
      end

      context "but target is not a valid host name" do
        let(:params) do
          {'type' => 'host', 'target' => 'http://not.a.host.name'}
        end

        it "must return success" do
          result = subject.call(params)

          expect(result).to be_failure
          expect(result.errors[:target]).to eq(["host must be a valid host name"])
        end
      end
    end

    context "when type is 'domain'" do
      context "and 'target' is a valid host name" do
        let(:params) do
          {'type' => 'domain', 'target' => 'localhost'}
        end

        it "must return success" do
          expect(subject.call(params)).to be_success
        end
      end

      context "but target is not a valid host name" do
        let(:params) do
          {'type' => 'domain', 'target' => 'http://not.a.host.name'}
        end

        it "must return success" do
          result = subject.call(params)

          expect(result).to be_failure
          expect(result.errors[:target]).to eq(["domain must be a valid host name"])
        end
      end
    end

    context "when type is 'site'" do
      context "and 'target' is a valid http:// URI" do
        let(:params) do
          {'type' => 'site', 'target' => 'http://example.com/'}
        end

        it "must return success" do
          expect(subject.call(params)).to be_success
        end
      end

      context "and 'target' is a valid https:// URI" do
        let(:params) do
          {'type' => 'site', 'target' => 'https://example.com/'}
        end

        it "must return success" do
          expect(subject.call(params)).to be_success
        end
      end

      context "but target is not a valid URI" do
        let(:params) do
          {'type' => 'site', 'target' => 'foo://not.a.http.uri'}
        end

        it "must return success" do
          result = subject.call(params)

          expect(result).to be_failure
          expect(result.errors[:target]).to eq(["site must be a valid http:// or https:// URI"])
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
