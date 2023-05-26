require 'spec_helper'
require 'schemas/params_schema'

require 'ronin/core/params/mixin'

describe "Schemas::ParamsSchema" do
  context "when the given params are empty" do
    module TestParamsSchema
      class ClassWithoutParams
        include Ronin::Core::Params::Mixin
      end
    end

    let(:params_class) { TestParamsSchema::ClassWithoutParams }

    subject { Schemas::ParamsSchema(params_class.params) }

    it "must build an empty schema" do
      expect(subject.call({})).to be_success
    end
  end

  context "when the given params are not empty" do
    module TestParamsSchema
      class ClassWithParams

        include Ronin::Core::Params::Mixin

        param :foo, Integer, required: true,
                             desc:     'A required param'

        param :bar, String, desc: 'An optional param'

      end
    end

    let(:params_class) { TestParamsSchema::ClassWithParams }

    subject { Schemas::ParamsSchema(params_class.params) }

    it "must build an empty schema" do
      result = subject.call({})

      expect(result).to be_failure
      expect(result.errors[:foo]).to eq(['is missing'])
    end
  end
end
