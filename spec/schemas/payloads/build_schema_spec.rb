require 'spec_helper'
require 'ronin/app/schemas/payloads/build_schema'

require 'ronin/payloads/payload'

describe "Ronin::App::Schemas::Payloads::BuildSchema" do
  context "when the given payload class has no params" do
    module TestBuildSchema
      class PayloadWithoutParams < Ronin::Payloads::Payload
      end
    end

    let(:payload_class) { TestBuildSchema::PayloadWithoutParams }

    subject { Ronin::App::Schemas::Payloads::BuildSchema(payload_class) }

    it "must build an empty schema" do
      expect(subject.call({})).to be_success
    end
  end

  context "when the given payload class has params" do
    module TestBuildSchema
      class PayloadWithParams < Ronin::Payloads::Payload

        param :foo, Integer, required: true,
                             desc:     'A required param'

        param :bar, String, desc: 'An optional param'

      end
    end

    let(:payload_class) { TestBuildSchema::PayloadWithParams }

    subject { Ronin::App::Schemas::Payloads::BuildSchema(payload_class) }

    it "must build an empty schema" do
      result = subject.call({params: {}})

      expect(result).to be_failure
      expect(result.errors[:params][:foo]).to eq(['is missing'])
    end
  end
end
