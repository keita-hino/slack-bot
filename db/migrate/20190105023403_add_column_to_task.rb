class AddColumnToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :started, :boolean, default:false
  end
end
