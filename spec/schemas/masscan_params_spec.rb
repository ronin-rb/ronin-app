require 'spec_helper'
require 'schemas/masscan_params'

describe "Schemas::MasscanParams" do
  subject { Schemas::MasscanParams }

  it "must require an :ips key" do
    result = subject.call({})

    expect(result).to be_failure
    expect(result.errors[:ips]).to eq(["is missing"])
  end
end
