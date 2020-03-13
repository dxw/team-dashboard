require "rails_helper"

RSpec.describe TeamMember, type: :model do
  subject { TeamMember.create(first_name: "Joe", last_name: "Smith", tenk_id: 1234) }

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_uniqueness_of(:tenk_id) }
    it { should belong_to(:project) }
  end

  describe "#name" do
    it "returns the first name of the person" do
      expect(subject.name).to eq "Joe"
    end
  end
end
