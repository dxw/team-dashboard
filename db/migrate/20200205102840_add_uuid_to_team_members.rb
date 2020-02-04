class AddUuidToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :uuid, :uuid 
  end
end
