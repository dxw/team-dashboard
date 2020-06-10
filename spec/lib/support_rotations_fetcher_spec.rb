require "rails_helper"
require "opsgenie_stubs"
require 'support_rotations_fetcher'

RSpec.describe "SupportRotationsFetcher" do
  before do
    stub_schedule
    stub_support_rotations
    stub_opsgenie_users
  end

  describe ".detect_stream" do
    it "recognises a number of known timelines by name" do
      expect(SupportRotationsFetcher.detect_stream("Oops")).to eq('ops')
    end
  end

  describe ".assigned" do
    it "returns the support periods with a non-nil user"
  end

  describe "FirstLineRotationsFetcher" do
    subject { FirstLineRotationsFetcher.new }

    it "returns the timelines with names matching the given expression" do
      expect(subject.call.map(&:name)).to match_array(["Ops", "Dev", "OOH"])
    end
  end
end
