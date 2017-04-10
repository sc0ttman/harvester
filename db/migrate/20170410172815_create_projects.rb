class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.integer :client_id
      t.string :name
      t.string :code
      t.boolean :active
      t.boolean :billable
      t.text :notes

      t.timestamps
    end
  end
end
