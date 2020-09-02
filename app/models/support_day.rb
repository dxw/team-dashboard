class SupportDay < ApplicationRecord
  DXW_SUPPORT_TYPES = %w[dev ops ooh1 ooh2].freeze

  belongs_to :team_member

  validates_presence_of :date
  validates_presence_of :support_type
end
