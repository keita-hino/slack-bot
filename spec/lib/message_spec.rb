require 'rails_helper'

describe Message do
  CHANNEL_ID = 'C999999'
  USER_ID = 'U999999'

  describe '#delete_message' do
    context 'when not found task' do
      it 'return not found designated message' do
        text = "not found"
        message = message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクが見つかりません:face_with_monocle:\n>>>" + text,
          as_user:false
        }
        expect(Message.delete_message(text,CHANNEL_ID)).to eq(message)
      end
    end

    context 'when task is found' do
      it 'return delete designated message' do
        FactoryBot.create(:task,completed:false,task_name:"deleted")
        text = "deleted"
        message = message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクを削除しました:+1:\n>>>" + text,
          as_user:false
        }
        expect(Message.delete_message(text,CHANNEL_ID)).to eq(message)
      end
    end
  end

  describe '#complete_message' do
    context 'when not found task' do
      it 'return not found designated message' do
        text = "not found"
        message = message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクが見つかりません:face_with_monocle:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,CHANNEL_ID)).to eq(message)
      end
    end

    context 'when already task is complete' do
      it 'return already complete designated message' do
        FactoryBot.create(:task,completed:true,task_name:"completed")
        text = "completed"
        message = message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクのステータスはすでに「完了」になってます:man-gesturing-no:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,CHANNEL_ID)).to eq(message)
      end
    end

    context 'when already task is complete' do
      it 'return already complete designated message' do
        FactoryBot.create(:task,completed:false,task_name:"complete")
        text = "complete"
        message = message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクのステータスを「完了」に変更しました:+1:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,CHANNEL_ID)).to eq(message)
      end
    end
  end

  describe '#add_message' do
    it 'return add message' do
      text = 'addアクション追加'
      message = {
        channel:CHANNEL_ID,
        text:"下記のタスクを追加しました\n>>>" + text,
        as_user:false
      }
      expect(Message.add_message(text,CHANNEL_ID)).to eq(message)
    end
  end

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
