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
    it "returns the first name of the person if their first name is unique within the existing team" do
      expect(subject.name).to eq "Joe"
    end

    context "for a person whose first name is not unique within the existing team" do
      before do
        TeamMember.create(first_name: "Joe", last_name: "Adamson", tenk_id: 1235)
      end

      it "returns the first name and the initial of the last name if they have one" do
        expect(subject.name).to eq "Joe S"
      end

      it "returns the first name of the person if that is their full name" do
        subject.last_name = ""

        expect(subject.name).to eq "Joe"
      end
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

  describe "#delivery_first" do
    it "returns 0 for people in the Delivery discipline" do
      subject.discipline = "Delivery"

      expect(subject.delivery_first).to eq(0)
    end

    it "returns 1 for people in any other discipline" do
      expect(subject.delivery_first).to eq(1)
    end
  end

  describe ".delivery_first" do
    it "sorts people in the Delivery discipline first, then everyone by name, case-insensitive" do
      delivery_lead2 = TeamMember.new(discipline: "Delivery", first_name: "Zaphod")
      delivery_lead1 = TeamMember.new(discipline: "Delivery", first_name: "Xander")
      xw = TeamMember.new(first_name: "Xena", last_name: "Warrior")
      xp = TeamMember.new(first_name: "Xena", last_name: "Princess")
      a = TeamMember.new(discipline: "Aarghing", first_name: "aardvark")
      team_members = [xw, a, xp, delivery_lead1, delivery_lead2]
      delivery_first = [delivery_lead1, delivery_lead2, a, xp, xw]

      expect(TeamMember.delivery_first(team_members)).to eq(delivery_first)
    end
  end
end
