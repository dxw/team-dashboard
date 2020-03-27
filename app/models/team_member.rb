class TeamMember < ApplicationRecord
  has_many :assignments
  has_many :projects, through: :assignments

  validates_presence_of :first_name
  validates_uniqueness_of :tenk_id

  def name
    first_name
  end
end
