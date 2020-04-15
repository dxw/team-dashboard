class CreateAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :assignments, id: :uuid do |t|
      t.belongs_to :project, type: :uuid, index: true
      t.belongs_to :team_member, index: true
    end
  end
end
