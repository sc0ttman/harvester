class AddOrganizationToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :organization_id, :integer
  end
end
