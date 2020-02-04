class RemoveColumnFromProjects < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :team_member_id
  end
end
