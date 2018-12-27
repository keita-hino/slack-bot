require 'rails_helper'

describe Message do
  CHANNEL_ID = 'C999999'
  USER_ID = 'U999999'

  describe '#show_result' do
    context 'when task empty' do
      it 'return empty designated message' do
        message = {
          channel:CHANNEL_ID,
          text:"タスクが登録されていません",
          as_user:false
        }
        expect(Message.show_result(USER_ID,CHANNEL_ID)).to eq(message)
      end
    end
    context 'when task not empty' do
      it 'return not empty designated message' do
        FactoryBot.create(:task)
        message = {
          channel:CHANNEL_ID,
          text:"タスク一覧\n>・test",
          as_user:false
        }
        expect(Message.show_result(USER_ID,CHANNEL_ID)).to eq(message)
      end
    end
  end

  describe '#template' do
    it 'is template correct' do
      text = "test"
      message = {
        channel:CHANNEL_ID,
        text: text,
        as_user: false
      }
      expect(Message.template(CHANNEL_ID,text)).to eq(message)
    end
  end

  describe '#help' do
    it 'is help message correct' do
      message = {
        channel:CHANNEL_ID,
        text: help_text,
        as_user: false
      }
      expect(Message.help(CHANNEL_ID)).to eq(message)
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
