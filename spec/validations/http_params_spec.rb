require 'spec_helper'
require 'ronin/app/validations/http_params'

describe Ronin::App::Validations::HTTPParams do
  describe 'HTTPMethods' do
    subject { described_class::HTTPMethods }

    it "must map 'COPY' to :copy" do
      expect(subject['COPY']).to eq(:copy)
    end

    it "must map 'DELETE' to :delete" do
      expect(subject['DELETE']).to eq(:delete)
    end

    it "must map 'GET' to :get" do
      expect(subject['GET']).to eq(:get)
    end

    it "must map 'HEAD' to :head" do
      expect(subject['HEAD']).to eq(:head)
    end

    it "must map 'LOCK' to :lock" do
      expect(subject['LOCK']).to eq(:lock)
    end

    it "must map 'MKCOL' to :mkcol" do
      expect(subject['MKCOL']).to eq(:mkcol)
    end

    it "must map 'MOVE' to :move" do
      expect(subject['MOVE']).to eq(:move)
    end

    it "must map 'OPTIONS' to :options" do
      expect(subject['OPTIONS']).to eq(:options)
    end

    it "must map 'PATCH' to :patch" do
      expect(subject['PATCH']).to eq(:patch)
    end

    it "must map 'POST' to :post" do
      expect(subject['POST']).to eq(:post)
    end

    it "must map 'PROPFIND' to :propfind" do
      expect(subject['PROPFIND']).to eq(:propfind)
    end

    it "must map 'PROPPATCH' to :proppatch" do
      expect(subject['PROPPATCH']).to eq(:proppatch)
    end

    it "must map 'PUT' to :put" do
      expect(subject['PUT']).to eq(:put)
    end

    it "must map 'TRACE' to :trace" do
      expect(subject['TRACE']).to eq(:trace)
    end

    it "must map 'UNLOCK' to :unlock" do
      expect(subject['UNLOCK']).to eq(:unlock)
    end
  end

  describe "Versions" do
    subject { described_class::Versions }

    it "must map '1.0' to 1" do
      expect(subject['1.0']).to eq(1)
    end

    it "must map '1.1' to 1.1" do
      expect(subject['1.1']).to eq(1.1)
    end

    it "must map '1.2' to 1.2" do
      expect(subject['1.2']).to eq(1.2)
    end
  end

  describe "VerificationModes" do
    subject { described_class::VerificationModes }

    it "must map 'none' to :none" do
      expect(subject['none']).to eq(:none)
    end

    it "must map 'peer' to :peer" do
      expect(subject['peer']).to eq(:peer)
    end

    it "must map 'fail_if_no_peer_cert' to :fail_if_no_peer_cert" do
      expect(subject['fail_if_no_peer_cert']).to eq(:fail_if_no_peer_cert)
    end
  end

  describe "Headers" do
    subject { described_class::Headers }

    context "when given a String" do
      it "must parse multiple 'Foo: bar' header lines into a Hash of names and values" do
        string = <<~HEADERS
          X-Foo: foo
          X-Bar: bar
        HEADERS

        expect(subject[string]).to eq(
          {
            'X-Foo' => 'foo',
            'X-Bar' => 'bar'
          }
        )
      end

      it "must group together repeated header names into an Array of values" do
        string = <<~HEADERS
          X-Foo: foo1
          X-Foo: foo2
          X-Bar: bar
        HEADERS

        expect(subject[string]).to eq(
          {
            'X-Foo' => ['foo1', 'foo2'],
            'X-Bar' => 'bar'
          }
        )
      end

      context "when it's empty" do
        it "must return nil" do
          expect(subject['']).to eq(nil)
        end
      end

      context "when it's whitespace" do
        it "must return nil" do
          expect(subject["\n  \n"]).to eq(nil)
        end
      end
    end
  end

  describe "rules" do
    let(:method) { 'GET' }
    let(:url)    { 'https://example.com/' }

    describe ":method" do
      it "must require an :method key" do
        result = subject.call({url: url})

        expect(result).to be_failure
        expect(result.errors[:method]).to eq(["is missing"])
      end
    end

    describe ":url" do
      it "must require an :url key" do
        result = subject.call({method: 'GET'})

        expect(result).to be_failure
        expect(result.errors[:url]).to eq(["is missing"])
      end
    end

    shared_examples_for "optional value" do |key|
      let(:params) do
        {method: method, url: url}
      end

      it "must coerce an empty value for #{key.inspect} into nil" do
        result = subject.call(params.merge(key => ""))

        expect(result).to be_success
        expect(result[key]).to be(nil)
      end
    end

    [
      :body,
      :headers,
      :proxy,
      :user_agent,
      :user,
      :password,
      :cookie
    ].each do |key|
      include_context "optional value", key
    end

    shared_examples_for "optional :ssl value" do |key|
      let(:params) do
        {method: method, url: url}
      end

      it "must coerce an empty value for #{key.inspect} into nil" do
        result = subject.call(params.merge(ssl: {key => ""}))

        expect(result).to be_success
        expect(result[:ssl][key]).to be(nil)
      end
    end

    [
      :timeout,
      :version,
      :min_version,
      :max_version,
      :verify,
      :verify_depth,
      :verify_hostname
    ].each do |key|
      include_context "optional :ssl value", key
    end
  end

  describe ".call" do
    subject { described_class }

    it "must initialize #{described_class} and call #call" do
      expect(subject.call({})).to be_kind_of(Dry::Validation::Result)
    end
  end
end
