class Task < ApplicationRecord
  def self.today_create_task
    Task.where(created_at: Time.now.midnight..(Time.now.midnight + 1.day - 1))
  end

  def self.today_completed_task
    Task.where(completed:true).where(updated_at: Time.now.midnight..(Time.now.midnight + 1.day - 1))
  end

  def self.incomplete_task
    Task.where(completed:false)
  end

  def self.started_task
    Task.where(completed:false,started:true)
  end

end
