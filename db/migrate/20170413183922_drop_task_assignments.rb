class DropTaskAssignments < ActiveRecord::Migration[5.0]
  def change
    drop_table :task_assignments
  end
end
