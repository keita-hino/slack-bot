class Task < ApplicationRecord
  acts_as_paranoid
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

  def self.show_task(text = 'not_task',user_id)
    case text
    when 'range:today'
      Task.where(user_id:user_id,created_at:Time.now.midnight..(Time.now.midnight + 1.day - 1)).order(:created_at)
    else
      Task.where(user_id:user_id).order(:created_at)
    end
  end

  def self.modify_task(text)
    if text.include?("started:")
      pat = /(.*)(started:)/
      text =~ pat
      t = Task.where(task_name:$1.strip)
      if t[0]
        t[0].started = true
        t[0].save
      else
        return false
      end
    end
  end

end
