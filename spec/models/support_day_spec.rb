require "rails_helper"

RSpec.describe SupportDay, type: :model do
  describe "validations" do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:support_type) }
  end
end
