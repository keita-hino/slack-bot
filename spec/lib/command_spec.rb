require 'rails_helper'

describe Command do
  describe '#report' do
    it 'is output report correct' do
      message = {
        channel:"C999999",
        text: "成功",
        as_user: false
      }
      expect(Command.report("C999999")).to eq(message)
    end
  end

  describe '#help' do
    it 'is help message correct' do
      message = {
        channel:"C999999",
        text: help_text,
        as_user: false
      }
      expect(Command.help("C999999")).to eq(message)
    end
  end

  def help_text
    <<-EOS
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
  end

end
