class ChangeRoleToDiscipline < ActiveRecord::Migration[6.0]
  def change
    rename_column :team_members, :role, :discipline
  end
end
