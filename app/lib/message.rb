class Message
  def self.delete_message(text,channel_id)
    result = Task.where(task_name:text).delete_all
    case result
    when 0
      message = "入力されたタスクが見つかりません:face_with_monocle:\n>>>#{text}"
    when 1
      message = "入力されたタスクを削除しました:+1:\n>>>#{text}"
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

  def self.add_message(text,channel_id)
    message = "下記のタスクを追加しました\n>>>" + text
    Message.template(channel_id,message)
  end

  def self.show_result(user_id,channel_id)
    s = Task.where(user_id:user_id)
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
      /task_show タスク名
        →タスクの一覧を表示する。これも日程の範囲をオプションで受け取れるようにするといいかも。
      /task_report
        →完了したタスクなどから、日報を作成する。
      /task_help
        →各種コマンドの説明を表示する。
    EOS

    self.template(channel_id,help_text)
  end
end
