class Project < ApplicationRecord
  has_many :team_members
  validates_presence_of :name
  validates_presence_of :tenk_id
end
