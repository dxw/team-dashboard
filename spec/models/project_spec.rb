require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:tenk_id) }
    it { should have_many(:team_members) }
  end

  describe "#active?" do
    context "when the project is not marked as 'archived'" do
      context "and the project ends today" do
        let(:project) { Project.new(ends_at: Date.today.to_s, archived: false) }

        it "is active" do
          expect(project).to be_active
        end
      end

      context "and the project ends after today" do
        let(:project) { Project.new(ends_at: Date.tomorrow.to_s, archived: false) }

        it "is active" do
          expect(project).to be_active
        end
      end

      context "and the project ended before today" do
        let(:project) { Project.new(ends_at: Date.yesterday.to_s, archived: false) }

        it "is not active" do
          expect(project).not_to be_active
        end
      end
    end

    context "when the project is archived" do
      let(:project) { Project.new(ends_at: Date.today.to_s, archived: true) }

      it "is not active" do
        expect(project).not_to be_active
      end
    end
  end
end
