require 'spec_helper'
require 'validations/import_params'

describe Validations::ImportParams do
  describe "rules" do
    context "when type is 'nmap'" do
      context "and the path ends with '.xml'" do
        let(:params) do
          {'type' => 'nmap', 'path' => '/path/to/file.xml'}
        end

        it "must return success" do
          expect(subject.call(params)).to be_success
        end
      end

      context "and the path does not end with '.xml'" do
        let(:params) do
          {'type' => 'nmap', 'path' => '/path/to/file.txt'}
        end

        it "must return failure" do
          result = subject.call(params)

          expect(result).to be_failure
          expect(result.errors[:path]).to eq(["nmap file path must end with .xml"])
        end
      end
    end

    context "when type is 'masscan'" do
      Masscan::OutputFile::FILE_FORMATS.each_key do |ext|
        context "and the path ends with '#{ext}'" do
          let(:params) do
            {'type' => 'masscan', 'path' => "/path/to/file#{ext}"}
          end

          it "must return success" do
            expect(subject.call(params)).to be_success
          end
        end
      end

      context "and the path ends with another file extension" do
        let(:params) do
          {'type' => 'masscan', 'path' => '/path/to/file.foo'}
        end

        it "must return failure" do
          result = subject.call(params)

          expect(result).to be_failure
          expect(result.errors[:path]).to eq(["masscan file path must end with #{Masscan::OutputFile::FILE_FORMATS.keys.join(', ')}"])
        end
      end
    end
  end
end
