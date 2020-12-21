class SupportDay < ApplicationRecord
  DXW_SUPPORT_TYPES = %w[dev ops ooh1 ooh2].freeze
  MONTHS_IN_THE_PAST_TO_DISPLAY = 2
  TOTAL_MONTHS_TO_DISPLAY = 12

  belongs_to :team_member

  validates_presence_of :date
  validates_presence_of :support_type

  default_scope -> { order(date: :asc) }

  scope :current, -> { where("? <= date AND date <= ?", interval_starting_wednesday.first, interval_starting_wednesday.last) }

  def self.interval_starting_wednesday(date = Date.today)
    interval_start = date << MONTHS_IN_THE_PAST_TO_DISPLAY
    until interval_start.wednesday?
      interval_start += 1
    end

    [interval_start, interval_start + TOTAL_MONTHS_TO_DISPLAY.months]
  end
end
