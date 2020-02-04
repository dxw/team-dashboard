class ChangeProjectIdToUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :project_id, :uuid 
  end
end
