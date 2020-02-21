class AddMetaFieldsToTeamMember < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :role, :string
    add_column :team_members, :thumbnail, :string
    add_column :team_members, :billable, :boolean
  end
end
