class CreateSupportDays < ActiveRecord::Migration[6.0]
  def change
    create_table :support_days, id: :uuid do |t|
      t.belongs_to :team_member, index: true, null: false
      t.date :date
      t.string :support_type
    end
  end
end
