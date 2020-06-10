class SupportDay < ApplicationRecord
  belongs_to :team_member

  validates_presence_of :date
  validates_presence_of :support_type
end
