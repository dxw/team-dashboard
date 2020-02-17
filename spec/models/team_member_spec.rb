require "rails_helper"

RSpec.describe TeamMember, type: :model do
  subject { TeamMember.create(name: "Joe", tenk_id: 1234) }

  describe "validations" do
    it { should validate_presence_of(:name) }
  end
end
