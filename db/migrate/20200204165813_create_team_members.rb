class CreateTeamMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :team_members, id: :uuid do |t|
      t.string :name
      t.string :role

      t.timestamps
    end
  end
end
