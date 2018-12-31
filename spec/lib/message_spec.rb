require 'rails_helper'

describe Message do
  CHANNEL_ID = 'C999999'
  USER_ID = 'U999999'

  describe '#report_message' do
    it 'report message correct' do
      FactoryBot.create(:task,task_name:"complete_task",completed:true)
      FactoryBot.create(:task,task_name:"incomplete_task",completed:false)

      message = message = {
        channel:CHANNEL_ID,
        text:"Today-Report\n\n本日追加されたタスク:new:\n\n>complete_task\n>incomplete_task\n\n本日完了したタスク:ok:\n\n>complete_task\n\n明日以降の残タスク:up:\n\n>incomplete_task",
        as_user:false
      }
      expect(Message.report_message(CHANNEL_ID)).to eq(message)
    end
  end

  describe '#report_create' do
    context 'when create list empty' do
      it 'message correct' do
        text = "Today-Report\n"
        message = "#{text}\n本日追加されたタスク:new:\n\n>本日登録されたタスクはまだありません\n"

        expect(Message.report_create(text)).to eq(message)
      end
    end
    context 'when create list not empty' do
      it 'report create list correct' do
        FactoryBot.create(:task,task_name:"create_task")
        text = "Today-Report\n"
        message = "#{text}\n本日追加されたタスク:new:\n\n>create_task"

        expect(Message.report_create(text)).to eq(message)
      end
    end
  end

  describe '#report_complete' do
    context 'when complete list empty' do
      it 'message correct' do
        text = "Today-Report\n"
        message = "#{text}\n\n本日完了したタスク:ok:\n\n>本日完了したタスクはまだありません\n"

        expect(Message.report_complete(text)).to eq(message)
      end
    end

    context 'when complete list not empty' do
      it 'report complete list correct' do
        FactoryBot.create(:task,task_name:"complete_task",completed:true)
        text = "Today-Report\n"
        message = "#{text}\n\n本日完了したタスク:ok:\n\n>complete_task"

        expect(Message.report_complete(text)).to eq(message)
      end
    end
  end

  describe '#report_incomplete' do
    context 'when incomplete list empty' do
      it 'message correct' do
        text = "Today-Report\n"
        message = "#{text}\n\n明日以降の残タスク:up:\n\n>明日以降の残タスクはありません\n"

        expect(Message.report_incomplete(text)).to eq(message)
      end
    end

    context 'when incomplete list not empty' do
      it 'report incomplete list correct' do
        FactoryBot.create(:task,task_name:"incomplete_task",completed:false)
        text = "Today-Report\n"
        message = "#{text}\n\n明日以降の残タスク:up:\n\n>incomplete_task"

        expect(Message.report_incomplete(text)).to eq(message)
      end
    end
  end

  describe '#delete_message' do
    context 'when not found task' do
      it 'message correct' do
        text = "not found"
        message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクが見つかりません:face_with_monocle:\n>" + text,
          as_user:false
        }
        expect(Message.delete_message(text,CHANNEL_ID)).to eq(message)
      end
    end

    context 'when task is found' do
      it 'delete designated task' do
        FactoryBot.create(:task,completed:false,task_name:"deleted")
        text = "deleted"
        message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクを削除しました:+1:\n>" + text,
          as_user:false
        }
        expect(Message.delete_message(text,CHANNEL_ID)).to eq(message)
      end
    end
  end

  describe '#complete_message' do
    context 'when not found task' do
      it 'message correct' do
        text = "not found"
        message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクが見つかりません:face_with_monocle:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,CHANNEL_ID)).to eq(message)
      end
    end

    context 'when already task is complete' do
      it 'already completed' do
        FactoryBot.create(:task,completed:true,task_name:"completed")
        text = "completed"
        message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクのステータスはすでに「完了」になってます:man-gesturing-no:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,CHANNEL_ID)).to eq(message)
      end
    end

    context 'when already task is complete' do
      it 'change to completion' do
        FactoryBot.create(:task,completed:false,task_name:"complete")
        text = "complete"
        message = {
          channel:CHANNEL_ID,
          text:"入力されたタスクのステータスを「完了」に変更しました:+1:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,CHANNEL_ID)).to eq(message)
      end
    end
  end

  describe '#add_message' do
    it 'add message' do
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
      it 'task is not registered' do
        message = {
          channel:CHANNEL_ID,
          text:"タスクが登録されていません",
          as_user:false
        }
        expect(Message.show_result(USER_ID,CHANNEL_ID)).to eq(message)
      end
    end
    context 'when task not empty' do
      it 'show reult correct' do
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
