require 'spec_helper'
require 'validations/install_repo_params'

describe Validations::InstallRepoParams do
  let(:uri) { 'https://github.com/foo/bar.git' }

  describe "rules" do
    describe ":uri" do
      it "must require a :uri key" do
        result = subject.call({})

        expect(result).to be_failure
        expect(result.errors[:uri]).to eq(["is missing"])
      end

      context "when :uri starts with 'https://'" do
        let(:uri) { 'https://github.com/foo/bar.git' }

        it "must accept 'https://' URIs" do
          result = subject.call({uri: uri})

          expect(result).to be_success
        end
      end

      context "when :uri starts with 'http://'" do
        let(:uri) { 'http://github.com/foo/bar.git' }

        it "must accept 'http://' URIs" do
          result = subject.call({uri: uri})

          expect(result).to be_success
        end
      end

      context "when :uri starts with 'ssh://'" do
        let(:uri) { 'ssh://user@github.com/foo/bar.git' }

        it "must accept 'ssh://' URIs" do
          result = subject.call({uri: uri})

          expect(result).to be_success
        end
      end

      context "when :uri starts with 'git://'" do
        let(:uri) { 'git://github.com/foo/bar.git' }

        it "must accept 'git://' URIs" do
          result = subject.call({uri: uri})

          expect(result).to be_success
        end
      end

      context "when :uri is a user@host.com:foo/bar.git style URI" do
        let(:uri) { 'git@github.com:foo/bar.git' }

        it "must accept user@host.com:foo/bar.git style URIs" do
          result = subject.call({uri: uri})

          expect(result).to be_success
        end
      end

      context "when :uri starts with an unknown scheme" do
        let(:uri) { 'foo://github.com/foo/bar.git' }

        it "must not accept unknown URI schemes" do
          result = subject.call({uri: uri})

          expect(result).to be_failure
          expect(result.errors[:uri]).to eq(['URI must be a https:// or a git@host:path/to/repo.git URI'])
        end
      end

      context "when :uri is just 'user@host.com'" do
        let(:uri) { 'user@host.com' }

        it "must not accept 'user@host.com' style URIs" do
          result = subject.call({uri: uri})

          expect(result).to be_failure
          expect(result.errors[:uri]).to eq(['URI must be a https:// or a git@host:path/to/repo.git URI'])
        end
      end

      context "when :uri is just 'user@host.com/path/to/repo'" do
        let(:uri) { 'user@host.com/path/to/repo' }

        it "must not accept 'user@host.com/path/to/repo' style URIs" do
          result = subject.call({uri: uri})

          expect(result).to be_failure
          expect(result.errors[:uri]).to eq(['URI must be a https:// or a git@host:path/to/repo.git URI'])
        end
      end
    end

    describe ":name" do
      it "must coerce an empty value for :name into nil" do
        result = subject.call({uri: uri, name: ""})

        expect(result).to be_success
        expect(result[:name]).to be(nil)
      end

      context "when :name contains alpha-numeric characters" do
        it "must accept alpha-numeric characters" do
          result = subject.call({uri: uri, name: 'foo42'})

          expect(result).to be_success
        end
      end

      context "when :name contains '-' characters" do
        it "must accept '-' characters" do
          result = subject.call({uri: uri, name: 'foo-bar'})

          expect(result).to be_success
        end
      end

      context "when :name contains '_' characters" do
        it "must accept '_' characters" do
          result = subject.call({uri: uri, name: 'foo_bar'})

          expect(result).to be_success
        end
      end

      context "when :name contains a '/'" do
        it "must not accept '/' characters in the name" do
          result = subject.call({uri: uri, name: 'foo/bar'})

          expect(result).to be_failure
          expect(result.errors[:name]).to eq(['repo name must only contain alpha-numeric, dashes, and underscores'])
        end
      end

      context "when :name contains a '.'" do
        it "must not accept '.' characters in the name" do
          result = subject.call({uri: uri, name: 'foo.bar'})

          expect(result).to be_failure
          expect(result.errors[:name]).to eq(['repo name must only contain alpha-numeric, dashes, and underscores'])
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
