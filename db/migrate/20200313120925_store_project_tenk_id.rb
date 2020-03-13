class StoreProjectTenkId < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :tenk_id, :integer, null: false
  end
end
