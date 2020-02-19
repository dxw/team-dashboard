class TeamMember < ApplicationRecord
  belongs_to :project, optional: true
  validates_presence_of :name
  validates_uniqueness_of :tenk_id
end
