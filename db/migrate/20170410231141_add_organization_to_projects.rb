class AddOrganizationToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :organization_id, :integer
  end
end
