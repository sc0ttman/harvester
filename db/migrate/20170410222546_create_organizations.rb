class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :code
      t.integer :harvest_project
      t.string :harvest_subdomain
      t.string :harvest_username
      t.string :harvest_password

      t.timestamps
    end
  end
end
