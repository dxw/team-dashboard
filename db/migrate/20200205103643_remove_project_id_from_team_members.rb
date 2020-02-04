class RemoveProjectIdFromTeamMembers < ActiveRecord::Migration[6.0]
  def change
    remove_column :team_members, :project_id
  end
end
