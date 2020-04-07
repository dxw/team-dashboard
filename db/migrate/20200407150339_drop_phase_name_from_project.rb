class DropPhaseNameFromProject < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :phase_name
  end
end
