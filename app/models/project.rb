class Project < ApplicationRecord
  TENK_ID_FOR_SUPPORT = 2360793

  has_many :assignments
  has_many :team_members, through: :assignments

  validates_presence_of :name
  validates_presence_of :tenk_id

  def active?
    !archived && Date.parse(ends_at) >= Date.today
  end
end
