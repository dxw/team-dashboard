class AddTenkIdToTeamMember < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :tenk_id, :integer, null: false 
  end
end
