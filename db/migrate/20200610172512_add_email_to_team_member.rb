class AddEmailToTeamMember < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :email, :string
    add_index :team_members, :email
  end
end
