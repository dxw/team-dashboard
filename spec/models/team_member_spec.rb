require "rails_helper"

RSpec.describe TeamMember, type: :model do
  subject { TeamMember.create(name: "Joe", tenk_id: 1234) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:tenk_id) }
    it { should belong_to(:project) }
  end
end
