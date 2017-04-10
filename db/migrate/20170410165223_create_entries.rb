class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.date :spent_at
      t.text :notes
      t.float :hours
      t.integer :user_id
      t.integer :project_id
      t.integer :task_id
      t.boolean :adjustment_record
      t.datetime :timer_started_at
      t.boolean :is_closed
      t.boolean :is_billed

      t.timestamps
    end
  end
end
