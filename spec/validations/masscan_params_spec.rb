require 'spec_helper'
require 'ronin/app/validations/masscan_params'

describe Ronin::App::Validations::MasscanParams do
  describe "rules" do
    describe ":ips" do
      it "must require an :ips key" do
        result = subject.call({ports: "80,443"})

        expect(result).to be_failure
        expect(result.errors[:ips]).to eq(["is missing"])
      end

      it "must require a non-empty value for :ips" do
        result = subject.call({ips: "", ports: "80,443"})

        expect(result).to be_failure
        expect(result.errors[:ips]).to eq(["is missing"])
      end

      it "must split the String value for :ips into an Array of Strings" do
        ip1    = '192.168.1.1'
        ip2    = '192.168.1.2'
        result = subject.call({ips: "#{ip1} #{ip2}", ports: "80,443"})

        expect(result).to be_success
        expect(result[:ips]).to eq([ip1, ip2])
      end
    end

    describe ":ports" do
      it "must require a :ports key" do
        result = subject.call({ips: "192.168.1.1"})

        expect(result).to be_failure
        expect(result.errors[:ports]).to eq(["is missing"])
      end

      it "must require a non-empty value for :ports" do
        result = subject.call({ips: "192.168.1.1", ports: ""})

        expect(result).to be_failure
        expect(result.errors[:ports]).to eq(["is missing"])
      end

      context "and when :ports is a valid masscan ports list" do
        it "must return a valid result" do
          result = subject.call({ips: '192.168.1.1', ports: "1,2,3,4-10"})

          expect(result).to be_success
        end
      end

      context "but when :ports is not a valid masscan ports list" do
        it "must reject invalid masscan ports list" do
          result = subject.call({ips: "192.168.1.1", ports: "1,2,3,xyz"})

          expect(result).to be_failure
          expect(result.errors[:ports]).to eq(["invalid masscan port list"])
        end
      end
    end

    shared_examples_for "optional value" do |key|
      let(:params) do
        {ips: '192.168.1.1', ports: "80,443"}
      end

      it "must coerce an empty value for #{key.inspect} into nil" do
        result = subject.call(params.merge(key => ""))

        expect(result).to be_success
        expect(result[key]).to be(nil)
      end
    end

    [
      :banners,
      :rate,
      :config_file,
      :adapter,
      :adapter_ip,
      :adapter_port,
      :adapter_mac,
      :adapter_vlan,
      :router_mac,
      :ping,
      :exclude,
      :exclude_file,
      :include_file,
      :retries,
      :pcap_payloads,
      :nmap_payloads,
      :http_method,
      :http_url,
      :http_version,
      :http_host,
      :http_user_agent,
      :http_field,
      :http_cookie,
      :http_payload,
      :open_only,
      :pcap,
      :packet_trace,
      :pfring,
      :shards,
      :seed,
      :ttl,
      :wait
    ].each do |key|
      include_context "optional value", key
    end
  end

  describe ".call" do
    subject { described_class }

    let(:params) do
      {ips: '192.168.1.1', ports: "80,443"}
    end

    it "must initialize #{described_class} and call #call" do
      expect(subject.call(params)).to be_kind_of(Dry::Validation::Result)
    end
  end
end
