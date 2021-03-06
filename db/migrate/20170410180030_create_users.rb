class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :is_admin
      t.string :first_name
      t.string :last_name
      t.boolean :is_contractor

      t.timestamps
    end
  end
end
