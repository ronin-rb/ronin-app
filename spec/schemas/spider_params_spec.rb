require 'spec_helper'
require 'schemas/spider_params'

describe "Schemas::SpiderParams" do
  subject { Schemas::SpiderParams }

  it "must require a :type key" do
    result = subject.call({target: 'example.com'})

    expect(result).to be_failure
    expect(result.errors[:type]).to eq(["is missing"])
  end

  it "must require a :target key" do
    result = subject.call({type: 'host'})

    expect(result).to be_failure
    expect(result.errors[:target]).to eq(["is missing"])
  end
end
