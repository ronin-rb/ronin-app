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

    shared_examples_for "optional value" do |key|
      it "must coerce an empty value for #{key.inspect} into nil" do
        result = subject.call({type: "host", target: 'example.com', key => ""})

        expect(result).to be_success
        expect(result[key]).to be(nil)
      end
    end

    [
      :host_header,
      :user_agent,
      :referer,
      :open_timeout,
      :read_timeout,
      :ssl_timeout,
      :continue_timeout,
      :keep_alive_timeout,
      :proxy,
      :delay,
      :limit,
      :max_depth,
      :strip_fragments,
      :strip_query,
      :host,
      :hosts,
      :ignore_hosts,
      :ports,
      :ignore_ports,
      :urls,
      :ignore_urls,
      :exts,
      :ignore_exts,
      :robots
    ].each do |key|
      include_context "optional value", key
    end
  end

  describe ".call" do
    subject { described_class }

    it "must initialize #{described_class} and call #call" do
      expect(subject.call({})).to be_kind_of(Dry::Validation::Result)
    end
  end
end
