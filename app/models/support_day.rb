class SupportDay < ApplicationRecord
  MONTHS_IN_THE_PAST = 2
  TOTAL_MONTHS = 12

  belongs_to :team_member

  validates_presence_of :date
  validates_presence_of :support_type

  scope :current, -> { where("? <= date AND date <= ?", interval_starting_wednesday.first, interval_starting_wednesday.last) }

  def self.interval_starting_wednesday(past_months: MONTHS_IN_THE_PAST, total_months: TOTAL_MONTHS)
    past_months = 0 if past_months < 0
    total_months = past_months if total_months < past_months

    interval_start = Date.today << past_months
    until interval_start.wednesday?
      interval_start += 1
    end

    [interval_start, interval_start + total_months.months]
  end
end
