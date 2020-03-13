require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:tenk_id) }
    it { should have_many(:team_members) }
  end
end
