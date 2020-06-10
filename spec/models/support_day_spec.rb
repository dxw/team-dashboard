require "rails_helper"

RSpec.describe SupportDay, type: :model do
  describe "validations" do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:support_type) }
  end

  describe ".current" do
    it "returns the rolling interval of support days"
  end

  describe ".interval_starting_wednesday" do
    it "returns an array of two dates one year apart"
  end
end
