class StoreFirstAndLastNames < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :first_name, :string
    add_column :team_members, :last_name, :string
    remove_column :team_members, :name, :string
  end
end
