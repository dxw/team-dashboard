class TeamMember < ApplicationRecord
  belongs_to :project, optional: true
  validates_presence_of :first_name
  validates_uniqueness_of :tenk_id

  def name
    first_name
  end
end
