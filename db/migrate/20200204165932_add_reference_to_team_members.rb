class AddReferenceToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_reference :team_members, :project, index: true
  end
end
