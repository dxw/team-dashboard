class ChangeProjectIdFromBigintToUuid < ActiveRecord::Migration[6.0]
  def up
    add_column :projects, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :projects, :id, :integer_id
    rename_column :projects, :uuid, :id
    execute "ALTER TABLE projects drop constraint projects_pkey;"
    execute "ALTER TABLE projects ADD PRIMARY KEY (id);"
    # Optinally you remove auto-incremented
    # default value for integer_id column
    execute "ALTER TABLE ONLY projects ALTER COLUMN integer_id DROP DEFAULT;"
    change_column_null :projects, :integer_id, true
    remove_column :projects, :integer_id
    execute "DROP SEQUENCE IF EXISTS projects_id_seq"
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
