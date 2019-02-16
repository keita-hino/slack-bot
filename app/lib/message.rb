class Message
  def self.modify_message(text,channel_id)
    result = Task.modify_task(text)
    if result
      message = "「完了」に修正しました"
    else
      message = "タスクが見つかりませんでした"
    end
    Message.template(channel_id,message)
  end

  def self.report_message(channel_id)
    message = "Today-Report\n"

    message = Message.report_create(message)
    message = Message.report_complete(message)
    message = Message.report_incomplete(message)
    message = Message.report_task_started(message)

    Message.template(channel_id,message)
  end

  def self.report_create(message)
    create_list = Task.today_create_task
    message << "\n本日追加されたタスク:new:\n"
    if create_list.blank?
      message << "\n>本日登録されたタスクはまだありません\n"
    else
      create_list.map{|v| message << "\n>" + v.task_name}
    end
    return message
  end

  def self.report_complete(message)
    complete_list = Task.today_completed_task
    message << "\n\n本日完了したタスク:ok:\n"
    if complete_list.blank?
      message << "\n>本日完了したタスクはまだありません\n"
    else
      complete_list.map{|v| message << "\n>" + v.task_name}
    end
    return message
  end

  def self.report_incomplete(message)
    incomplete_list = Task.incomplete_task
    message << "\n\n残タスク:up:\n"
    if incomplete_list.blank?
      message << "\n>残タスクはありません\n"
    else
      incomplete_list.map{|v| message << "\n>" + v.task_name}
    end
    return message
  end

  def self.report_task_started(message)
    started_task_list = Task.started_task
    message << "\n\n着手中のタスク:man-running:\n"
    if started_task_list.blank?
      message << "\n>着手中のタスクはありません\n"
    else
      started_task_list.map{|v| message << "\n>" + v.task_name}
    end
    return message
  end

  def self.delete_message(text,channel_id)
    result = Task.where(task_name:text).destroy_all
    if result.empty?
      message = "入力されたタスクが見つかりません:face_with_monocle:\n>#{text}"
    else
      message = "入力されたタスクを削除しました:+1:\n>#{text}"
    end
    Message.template(channel_id,message)
  end

  def self.complete_message(text,channel_id)
    s = Task.where(task_name:text)
    if s[0].nil?
      message = "入力されたタスクが見つかりません:face_with_monocle:\n>>>#{text}"
    elsif !(s[0].completed.blank?)
      message = "入力されたタスクのステータスはすでに「完了」になってます:man-gesturing-no:\n>>>#{text}"
    elsif s[0].completed.blank?
      s[0].completed = true
      s[0].save
      message = "入力されたタスクのステータスを「完了」に変更しました:+1:\n>>>#{text}"
    end
    Message.template(channel_id,message)
  end

  def self.add_message(text,channel_id,user_id)
    due_date = ""
    if text.include?("due:")
      pat = /(due:)(.*)/
      text =~ pat
      due_date = $2
      text.gsub!($1 + $2," ")
    else
      due_date = (Time.now.midnight + 1.day - 1)
    end

    Task.create(
      user_id:user_id,
      task_name:text.strip,
      due_date:due_date
    )
    message = "下記のタスクを追加しました\n>>>" + text
    Message.template(channel_id,message)
  end

  def self.show_result(text = "not_option",user_id,channel_id)
    s = Task.show_task(text,user_id)
    if s[0].blank?
      message = Message.template(channel_id,"タスクが登録されていません")
    else
      task = "タスク一覧"
      s.map{|v| task << "\n>・" + v.task_name }
      message = Message.template(channel_id,task)
    end
  end

  def self.template(channel_id,text)
    {
      channel:channel_id,
      text: text,
      as_user: false
    }
  end

  def self.help(channel_id)
    help_text = <<-EOS
      スラッシュコマンド一覧
      /task_add タスク名 due: 21:00
        →タスクを追加する。dueオプションをつけると期限を設定することができる。
      /task_remove タスク名
        →タスクを削除する。
      /task_complete タスク名
        →タスクのステータスを「完了」にする。
      /task_show タスク名 range:today
        →タスクの一覧を表示する。rangeオプションを指定することで任意の範囲のタスク一覧を取得することができる。
      /task_report
        →完了したタスクなどから、日報を作成する。
      /task_modify
        →タスクのステータスを変更する。
      /task_help
        →各種コマンドの説明を表示する。
    EOS

    self.template(channel_id,help_text)
  end
end
