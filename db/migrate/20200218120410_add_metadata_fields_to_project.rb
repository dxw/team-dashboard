class AddMetadataFieldsToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :starts_at, :string
    add_column :projects, :ends_at, :string
    add_column :projects, :client, :string
    add_column :projects, :phase_name, :string
    add_column :projects, :archived, :boolean
  end
end
