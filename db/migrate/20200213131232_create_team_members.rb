class CreateTeamMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :team_members do |t|
      t.references :project, type: :uuid, index: true
      t.string :name
    end
  end
end
