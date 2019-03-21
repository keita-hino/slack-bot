100.times do |i|
  Task.create(
    user_id:ENV['SLACK_USER_TEST'],
    task_name:"タスク#{i}",
    completed:false,
    due_date:Time.now,
    started:false
  )
end
