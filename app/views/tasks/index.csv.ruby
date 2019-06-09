require 'csv'

CSV.generate do |csv|
  column_names = %w(タスク名 完了 期限日 最終更新日)
  csv << column_names
  @tasks.each do |task|
    column_values = [
      task.task_name,
      task.completed,
      task.due_date,
      task.updated_at
    ]
    csv << column_values
  end
end
