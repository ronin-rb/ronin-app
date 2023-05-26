require 'spec_helper'
require 'schemas/payloads/encoders/encode_schema'

require 'ronin/payloads/encoders/encoder'

describe "Schemas::Payloads::Encoders::EncodeSchema" do
  context "when the given payload class has no params" do
    module TestEncodeSchema
      class EncoderWithoutParams < Ronin::Payloads::Encoders::Encoder
      end
    end

    let(:encoder_class) { TestEncodeSchema::EncoderWithoutParams }

    subject { Schemas::Payloads::Encoders::EncodeSchema(encoder_class) }

    it "must build an empty :params schema" do
      expect(subject.call({data: 'foo'})).to be_success
    end

    it "must still require a :data key" do
      expect(subject.call({})).to be_failure
      expect(subject.call({data: 'foo'})).to be_success
    end

    it "must require a non-empty value for :data" do
      expect(subject.call({data: ''})).to be_failure
      expect(subject.call({data: 'foo'})).to be_success
    end
  end

  context "when the given payload class has params" do
    module TestEncodeSchema
      class EncoderWithParams < Ronin::Payloads::Encoders::Encoder

        param :foo, Integer, required: true,
                             desc:     'A required param'

        param :bar, String, desc: 'An optional param'

      end
    end

    let(:encoder_class) { TestEncodeSchema::EncoderWithParams }

    subject { Schemas::Payloads::Encoders::EncodeSchema(encoder_class) }

    it "must build an empty schema" do
      result = subject.call({data: 'foo', params: {}})

      expect(result).to be_failure
      expect(result.errors[:params][:foo]).to eq(['is missing'])
    end

    it "must still require a :data key" do
      expect(subject.call({params: {foo: 42}})).to be_failure
      expect(subject.call({data: 'foo', params: {foo: 42}})).to be_success
    end
  end
end
