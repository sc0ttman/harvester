class AddOrganizationToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :organization_id, :integer
  end
end
