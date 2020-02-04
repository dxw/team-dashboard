class DropTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :projects
    drop_table :team_members
  end
end
