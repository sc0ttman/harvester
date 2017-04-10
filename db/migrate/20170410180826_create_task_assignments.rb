class CreateTaskAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :task_assignments do |t|
      t.integer :project_id
      t.integer :task_id
      t.boolean :deactivated

      t.timestamps
    end
  end
end
