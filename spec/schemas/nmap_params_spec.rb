require 'spec_helper'
require 'schemas/nmap_params'

describe "Schemas::NmapParams" do
  subject { Schemas::NmapParams }

  it "must require a :targets key" do
    result = subject.call({})

    expect(result).to be_failure
    expect(result.errors[:targets]).to eq(["is missing"])
  end
end
