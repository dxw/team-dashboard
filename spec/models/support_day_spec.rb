require "rails_helper"

RSpec.describe SupportDay, type: :model do
  describe "validations" do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:support_type) }
  end

  describe ".current" do
    it "returns the rolling interval of support days" do
      team_member = TeamMember.create(first_name: "Jay", tenk_id: 1)
      current_day = team_member.support_days.create(date: Date.today, support_type: "ops")
      historical_day = team_member.support_days.create(date: 3.months.ago, support_type: "ops")

      expect(SupportDay.current).to include(current_day)
      expect(SupportDay.current).not_to include(historical_day)
    end
  end

  describe ".interval_starting_wednesday" do
    let(:date) { Date.new(2020, 9, 14) }
    let(:interval) { SupportDay.interval_starting_wednesday(date) }

    it "always starts on a Wednesday" do
      (date..(date + 6)).each do |d|
        expect(SupportDay.interval_starting_wednesday(d).first.wednesday?).to be_truthy
      end
    end

    it "starts MONTHS_IN_THE_PAST_TO_DISPLAY months ago" do
      expect(interval.first.to_s).to eq("2020-07-15")
    end

    it "ends TOTAL_MONTHS_TO_DISPLAY later from the start date" do
      expect(interval.last.to_s).to eq("2021-07-15")
    end
  end
end
