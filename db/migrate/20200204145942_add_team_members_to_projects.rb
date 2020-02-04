class AddTeamMembersToProjects < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :team_member, index: true 
  end
end
