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

        it "must return failure" do
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

        it "must return failure" do
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

        it "must return failure" do
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

    it "must split the :hosts String into an Array of Strings" do
      host1 = 'www1.example.com'
      host2 = 'www2.example.com'
      hosts = "#{host1}, #{host2}"

      result = subject.call(
        type:   'host',
        target: 'example.com',
        hosts:  hosts
      )

      expect(result).to be_success
      expect(result[:hosts]).to eq([host1, host2])
    end

    it "must split the :ignore_hosts String into an Array of Strings" do
      host1 = 'www1.example.com'
      host2 = 'www2.example.com'
      hosts = "#{host1}, #{host2}"

      result = subject.call(
        type:         'host',
        target:       'example.com',
        ignore_hosts: hosts
      )

      expect(result).to be_success
      expect(result[:ignore_hosts]).to eq([host1, host2])
    end

    it "must split the :ports String into an Array of Strings" do
      port1 = 80
      port2 = 443
      ports = "#{port1}, #{port2}"

      result = subject.call(
        type:   'host',
        target: 'example.com',
        ports:  ports
      )

      expect(result).to be_success
      expect(result[:ports]).to eq([port1, port2])
    end

    it "must split the :ignore_ports String into an Array of Strings" do
      port1 = 80
      port2 = 443
      ports = "#{port1}, #{port2}"

      result = subject.call(
        type:         'host',
        target:       'example.com',
        ignore_ports: ports
      )

      expect(result).to be_success
      expect(result[:ignore_ports]).to eq([port1, port2])
    end

    it "must split the :urls String into an Array of Strings" do
      url1 = 'https://www1.example.com'
      url2 = 'https://www2.example.com'
      urls = "#{url1}, #{url2}"

      result = subject.call(
        type:   'host',
        target: 'example.com',
        urls:   urls
      )

      expect(result).to be_success
      expect(result[:urls]).to eq([url1, url2])
    end

    it "must split the :ignore_urls String into an Array of Strings" do
      url1 = 'https://www1.example.com'
      url2 = 'https://www2.example.com'
      urls = "#{url1}, #{url2}"

      result = subject.call(
        type:         'host',
        target:       'example.com',
        ignore_urls:  urls
      )

      expect(result).to be_success
      expect(result[:ignore_urls]).to eq([url1, url2])
    end

    it "must split the :exts String into an Array of Strings" do
      ext1 = '.html'
      ext2 = '.xhtml'
      exts = "#{ext1}, #{ext2}"

      result = subject.call(
        type:   'host',
        target: 'example.com',
        exts:   exts
      )

      expect(result).to be_success
      expect(result[:exts]).to eq([ext1, ext2])
    end

    it "must split the :ignore_exts String into an Array of Strings" do
      ext1 = '.zip'
      ext2 = '.rar'
      exts = "#{ext1}, #{ext2}"

      result = subject.call(
        type:         'host',
        target:       'example.com',
        ignore_exts:  exts
      )

      expect(result).to be_success
      expect(result[:ignore_exts]).to eq([ext1, ext2])
    end
  end

  describe ".call" do
    subject { described_class }

    it "must initialize #{described_class} and call #call" do
      expect(subject.call({})).to be_kind_of(Dry::Validation::Result)
    end
  end
end
