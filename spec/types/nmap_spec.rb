require 'spec_helper'
require 'ronin/app/types/nmap'

describe Ronin::App::Types::Nmap do
  describe "Time" do
    subject { described_class::Time }

    it "must accept a decimal number" do
      expect(subject["10"]).to eq("10")
    end

    it "must accept a number with the 'ms' suffix" do
      expect(subject["10ms"]).to eq("10ms")
    end

    it "must accept a number with the 's' suffix" do
      expect(subject["10s"]).to eq("10s")
    end

    it "must accept a number with the 'm' suffix" do
      expect(subject["10m"]).to eq("10m")
    end

    it "must accept a number with the 'h' suffix" do
      expect(subject["10h"]).to eq("10h")
    end

    it "must not accept other suffixes" do
      expect {
        subject["10x"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept non-numbers" do
      expect {
        subject["abc"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept empty Strings" do
      expect {
        subject[""]
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "HexString" do
    subject { described_class::HexString }

    it "must accept decimal strings" do
      expect(subject["0123456789"]).to eq("0123456789")
    end

    it "must accept uppercase hexadecimal strings" do
      expect(subject["0123456789ABCDEF"]).to eq("0123456789ABCDEF")
    end

    it "must accept uppercase hexadecimal strings prefixed with a '0x'" do
      expect(subject["0x0123456789ABCDEF"]).to eq("0x0123456789ABCDEF")
    end

    it "must accept '\\x' escaped uppercase-hex character strings" do
      expect(subject["\\x42\\xFF"]).to eq("\\x42\\xFF")
    end

    it "must not accept lowercase hexadecimal strings prefixed with a '0x'" do
      expect {
        subject["0123456789abcdef"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept lowercase `\\x` hex strings" do
      expect {
        subject["\\xff"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept non-hexadecimal strings" do
      expect {
        subject["xyz"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept empty Strings" do
      expect {
        subject[""]
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "Port" do
    subject { described_class::Port }

    it "must accept a single interger value" do
      expect(subject["80"]).to eq("80")
    end

    it "must accept a single service name" do
      expect(subject["http"]).to eq("http")
    end

    it "must accept a service name ending with a '*' character" do
      expect(subject["http*"]).to eq("http*")
    end

    it "must accept service names containing uppercase letters" do
      expect(subject["XmlIpcRegSvc"]).to eq("XmlIpcRegSvc")
    end

    it "must accept service containing digits" do
      expect(subject["neo4j"]).to eq("neo4j")
    end

    it "must not accept service names starting with digits" do
      expect {
        subject["1ci-smcs"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must accept service names containing a '-' character" do
      expect(subject["iphone-sync"]).to eq("iphone-sync")
    end

    it "must accept service names containing a '_' character" do
      expect(subject["kerberos_master"]).to eq("kerberos_master")
    end

    it "must accept service names containing a '/' character" do
      expect(subject["cl/1"]).to eq("cl/1")
    end

    it "must not accept service names starting with a '-' character" do
      expect {
        subject["-foo"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept service names starting with a '_' character" do
      expect {
        subject["_foo"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept service names starting with a '/' character" do
      expect {
        subject["/foo"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept service names ending with a '_' character" do
      expect {
        subject["foo_"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept service names ending with a '/' character" do
      expect {
        subject["foo/"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept a negative number" do
      expect {
        subject["-1"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept a 0" do
      expect {
        subject["0"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept a number greater than 65535" do
      expect {
        subject["65536"]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept an empty String" do
      expect {
        subject[""]
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "PortRange" do
    subject { described_class::PortRange }

    it "must accept a single interger value" do
      expect(subject["80"]).to eq("80")
    end

    it "must accept a single service name" do
      expect(subject["http"]).to eq("http")
    end

    it "must accept a service name ending with a '*' character" do
      expect(subject["http*"]).to eq("http*")
    end

    it "must accept service names containing uppercase letters" do
      expect(subject["XmlIpcRegSvc"]).to eq("XmlIpcRegSvc")
    end

    it "must accept service containing digits" do
      expect(subject["neo4j"]).to eq("neo4j")
    end

    it "must accept service names containing a '-' character" do
      expect(subject["iphone-sync"]).to eq("iphone-sync")
    end

    it "must accept service names containing a '_' character" do
      expect(subject["kerberos_master"]).to eq("kerberos_master")
    end

    it "must accept service names containing a '/' character" do
      expect(subject["cl/1"]).to eq("cl/1")
    end

    it "must accept a port range of two port numbers" do
      expect(subject["1-1024"]).to eq("1-1024")
    end

    it "must accept a port range with the first number omitted" do
      expect(subject["-1024"]).to eq("-1024")
    end

    it "must accept a port range with the last number omitted" do
      expect(subject["1024-"]).to eq("1024-")
    end

    it "must not accept an empty String" do
      expect {
        subject[""]
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "PortRangeList" do
    subject { described_class::PortRangeList }

    it "must accept a single interger value" do
      expect(subject["80"]).to eq("80")
    end

    it "must accept a single service name" do
      expect(subject["http"]).to eq("http")
    end

    it "must accept a service name ending with a '*' character" do
      expect(subject["http*"]).to eq("http*")
    end

    it "must accept service names containing uppercase letters" do
      expect(subject["XmlIpcRegSvc"]).to eq("XmlIpcRegSvc")
    end

    it "must accept service containing digits" do
      expect(subject["neo4j"]).to eq("neo4j")
    end

    it "must accept service names containing a '-' character" do
      expect(subject["iphone-sync"]).to eq("iphone-sync")
    end

    it "must accept service names containing a '_' character" do
      expect(subject["kerberos_master"]).to eq("kerberos_master")
    end

    it "must accept service names containing a '/' character" do
      expect(subject["cl/1"]).to eq("cl/1")
    end

    it "must accept a port range of two port numbers" do
      expect(subject["1-1024"]).to eq("1-1024")
    end

    it "must accept a port range with the first number omitted" do
      expect(subject["-1024"]).to eq("-1024")
    end

    it "must accept a port range with the last number omitted" do
      expect(subject["1024-"]).to eq("1024-")
    end

    it "must accept multiple comma-separated port numbers" do
      expect(subject['1,80,443,8080']).to eq('1,80,443,8080')
    end

    it "must accept multiple comma-separated port ranges" do
      expect(subject['1-80,443-8080']).to eq('1-80,443-8080')
    end

    it "must accept a single interger value, with protocol prefixes" do
      expect(subject["T:80"]).to eq("T:80")
    end

    it "must accept a single service name, with protocol prefixes" do
      expect(subject["T:http"]).to eq("T:http")
    end

    it "must accept a port range of two port numbers, with protocol prefixes" do
      expect(subject["T:1-1024"]).to eq("T:1-1024")
    end

    it "must accept a port range with the first number omitted, with protocol prefixes" do
      expect(subject["T:-1024"]).to eq("T:-1024")
    end

    it "must accept a port range with the last number omitted, with protocol prefixes" do
      expect(subject["T:1024-"]).to eq("T:1024-")
    end

    it "must accept multiple comma-separated port numbers and port ranges" do
      expect(subject['1-24,80,443,8000-9000']).to eq('1-24,80,443,8000-9000')
    end

    it "must accept multiple comma-separated port numbers, with protocol prefixes" do
      expect(subject['T:1,T:80,T:443,U:8080']).to eq('T:1,T:80,T:443,U:8080')
    end

    it "must accept multiple comma-separated port ranges, with protocol prefixes" do
      expect(subject['T:1-80,T:443-8080']).to eq('T:1-80,T:443-8080')
    end

    it "must accept multiple comma-separated port numbers and port ranges, with protocol prefixes" do
      expect(subject['T:1-24,T:80,T:443,U:8000-9000']).to eq('T:1-24,T:80,T:443,U:8000-9000')
    end

    it "must not accept an empty String" do
      expect {
        subject[""]
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "ProtocolList" do
    subject { described_class::ProtocolList }

    it "must accept a single interger value" do
      expect(subject["80"]).to eq("80")
    end

    it "must accept a single service name" do
      expect(subject["http"]).to eq("http")
    end

    it "must accept a service name ending with a '*' character" do
      expect(subject["http*"]).to eq("http*")
    end

    it "must accept service names containing uppercase letters" do
      expect(subject["XmlIpcRegSvc"]).to eq("XmlIpcRegSvc")
    end

    it "must accept service containing digits" do
      expect(subject["neo4j"]).to eq("neo4j")
    end

    it "must accept service names containing a '-' character" do
      expect(subject["iphone-sync"]).to eq("iphone-sync")
    end

    it "must accept service names containing a '_' character" do
      expect(subject["kerberos_master"]).to eq("kerberos_master")
    end

    it "must accept service names containing a '/' character" do
      expect(subject["cl/1"]).to eq("cl/1")
    end

    it "must accept a port range of two port numbers" do
      expect(subject["1-1024"]).to eq("1-1024")
    end

    it "must accept a port range with the first number omitted" do
      expect(subject["-1024"]).to eq("-1024")
    end

    it "must accept a port range with the last number omitted" do
      expect(subject["1024-"]).to eq("1024-")
    end

    it "must accept multiple comma-separated port numbers" do
      expect(subject['1,80,443,8080']).to eq('1,80,443,8080')
    end

    it "must accept multiple comma-separated port ranges" do
      expect(subject['1-80,443-8080']).to eq('1-80,443-8080')
    end

    it "must accept a single interger value, with protocol prefixes" do
      expect(subject["T:80"]).to eq("T:80")
    end

    it "must accept a single service name, with protocol prefixes" do
      expect(subject["T:http"]).to eq("T:http")
    end

    it "must accept a port range of two port numbers, with protocol prefixes" do
      expect(subject["T:1-1024"]).to eq("T:1-1024")
    end

    it "must accept a port range with the first number omitted, with protocol prefixes" do
      expect(subject["T:-1024"]).to eq("T:-1024")
    end

    it "must accept a port range with the last number omitted, with protocol prefixes" do
      expect(subject["T:1024-"]).to eq("T:1024-")
    end

    it "must accept multiple comma-separated port numbers and port ranges" do
      expect(subject['1-24,80,443,8000-9000']).to eq('1-24,80,443,8000-9000')
    end

    it "must accept multiple comma-separated port numbers, with protocol prefixes" do
      expect(subject['T:1,T:80,T:443,U:8080']).to eq('T:1,T:80,T:443,U:8080')
    end

    it "must accept multiple comma-separated port ranges, with protocol prefixes" do
      expect(subject['T:1-80,T:443-8080']).to eq('T:1-80,T:443-8080')
    end

    it "must accept multiple comma-separated port numbers and port ranges, with protocol prefixes" do
      expect(subject['T:1-24,T:80,T:443,U:8000-9000']).to eq('T:1-24,T:80,T:443,U:8000-9000')
    end

    it "must not accept an empty String" do
      expect {
        subject[""]
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "ScanFlag" do
    subject { described_class::ScanFlag }

    {
      urg: 'urg',
      ack: 'ack',
      psh: 'psh',
      rst: 'rst',
      syn: 'syn',
      fin: 'fin'
    }.each do |symbol,string|
      it "must map '#{string}' to #{symbol.inspect}" do
        expect(subject[string]).to be(symbol)
      end

      it "must accept a #{symbol.inspect} symbol" do
        expect(subject[symbol]).to be(symbol)
      end
    end

    it "must not accept unknown String values" do
      expect {
        subject['foo']
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept unknown Symbol values" do
      expect {
        subject[:foo]
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "ScanFlags" do
    subject { described_class::ScanFlags }

    it "must map an Array of String values to an Array of Symbols" do
      expect(subject[['syn', 'ack']]).to eq([:syn, :ack])
    end

    it "must accept an Array of Symbols" do
      expect(subject[[:syn, :ack]]).to eq([:syn, :ack])
    end

    it "must not accept Arrays containing unknown String values" do
      expect {
        subject[['syn', 'foo']]
      }.to raise_error(Dry::Types::ConstraintError)
    end

    it "must not accept Arrays containing unknown Symbol values" do
      expect {
        subject[[:syn, :foo]]
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "NsockEngine" do
    subject { described_class::NsockEngine }

    %w[iocp epoll kqueue poll select].each do |value|
      it "must accept '#{value}'" do
        expect(subject[value]).to eq(value)
      end
    end

    it "must not accept other Strings" do
      expect {
        subject['foo']
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "TimingTemplate" do
    subject { described_class::TimingTemplate }

    %w[paranoid sneaky polite normal aggressive insane].each do |value|
      it "must accept '#{value}'" do
        expect(subject[value]).to eq(value)
      end
    end

    it "must not accept other Strings" do
      expect {
        subject['foo']
      }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
