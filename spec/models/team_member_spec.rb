require "rails_helper"
require "pry"

RSpec.describe TeamMember, type: :model do
  subject { TeamMember.create(first_name: "Joe", last_name: "Smith", tenk_id: 1234) }

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_uniqueness_of(:tenk_id) }
    it { should have_many(:projects) }
  end

  describe "#name" do
    it "returns the first name of the person" do
      expect(subject.name).to eq "Joe"
    end
  end

  describe "#job_title" do
    it "returns the job title matching the discipline" do
      team_member_one = TeamMember.new(discipline: "Development")
      team_member_two = TeamMember.new(discipline: "Delivery")
      team_member_three = TeamMember.new(discipline: "Research")
      team_member_four = TeamMember.new(discipline: "Service Design")
      team_member_five = TeamMember.new(discipline: "Design")
      team_member_six = TeamMember.new(discipline: "Operations Engineering")
      team_member_seven = TeamMember.new(discipline: "Strategy")
      team_member_eight = TeamMember.new(discipline: "Technical Architecture")
      team_member_nine = TeamMember.new(discipline: "Product")

      expect(team_member_one.job_title).to eq "Developer"
      expect(team_member_two.job_title).to eq "Delivery Lead"
      expect(team_member_three.job_title).to eq "User Researcher"
      expect(team_member_four.job_title).to eq "Service Designer"
      expect(team_member_five.job_title).to eq "Designer"
      expect(team_member_six.job_title).to eq "Operations Engineer"
      expect(team_member_seven.job_title).to eq "Strategist"
      expect(team_member_eight.job_title).to eq "Technical Architect"
      expect(team_member_nine.job_title).to eq "Product Manager"
    end

    it "returns 10k ft discipline when theres an unexpected discipline" do
      team_member_one = TeamMember.new(discipline: "foo")

      expect(team_member_one.job_title).to eq "foo"
    end
  end

end
