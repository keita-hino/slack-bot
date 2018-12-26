class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :user_id
      t.string :task_name
      t.boolean :completed,default: false
      t.datetime :due_date

      t.timestamps
    end
  end
end
