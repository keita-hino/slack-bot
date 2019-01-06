require 'rails_helper'

describe Message do
  let(:channel_id) {'C999999'}
  let(:user_id) {'U999999'}

  describe '#modify_message' do
    context 'when started option attached' do
      it 'return complte message' do
        FactoryBot.create(:task,task_name:"test",started:false)
        text = 'test started:'
        message = message = {
          channel: "C999999",
          text: "「完了」に修正しました",
          as_user: false
        }
        expect(Message.modify_message(text,channel_id)).to eq(message)
      end
    end

    context 'when started option not attached' do
      it 'return not complete message' do
        FactoryBot.create(:task,task_name:"test",started:false)
        text = 'test'
        message = message = {
          channel: "C999999",
          text: "タスクが見つかりませんでした",
          as_user: false
        }
        expect(Message.modify_message(text,channel_id)).to eq(message)
      end
    end

  end

  describe '#report_message' do
    it 'report message correct' do
      FactoryBot.create(:task,task_name:"complete_task",completed:true)
      FactoryBot.create(:task,task_name:"incomplete_task",completed:false,started:true)

      message = message = {
        channel:channel_id,
        text:"Today-Report\n\n本日追加されたタスク:new:\n\n>complete_task\n>incomplete_task\n\n本日完了したタスク:ok:\n\n>complete_task\n\n残タスク:up:\n\n>incomplete_task\n\n着手中のタスク:man-running:\n\n>incomplete_task",
        as_user:false
      }
      expect(Message.report_message(channel_id)).to eq(message)
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
        message = "#{text}\n\n残タスク:up:\n\n>残タスクはありません\n"

        expect(Message.report_incomplete(text)).to eq(message)
      end
    end

    context 'when incomplete list not empty' do
      it 'report incomplete list correct' do
        FactoryBot.create(:task,task_name:"incomplete_task",completed:false)
        text = "Today-Report\n"
        message = "#{text}\n\n残タスク:up:\n\n>incomplete_task"

        expect(Message.report_incomplete(text)).to eq(message)
      end
    end
  end

  describe '#report_task_started' do
    context 'when task started list empty' do
      it 'message correct' do
        text = "Today-Report\n"
        message = "#{text}\n\n着手中のタスク:man-running:\n\n>着手中のタスクはありません\n"

        expect(Message.report_task_started(text)).to eq(message)
      end
    end

    context 'when incomplete list not empty' do
      it 'report task started list correct' do
        FactoryBot.create(:task,task_name:"started_task",completed:false,started:true)
        text = "Today-Report\n"
        message = "#{text}\n\n着手中のタスク:man-running:\n\n>started_task"

        expect(Message.report_task_started(text)).to eq(message)
      end
    end
  end

  describe '#delete_message' do
    context 'when not found task' do
      it 'message correct' do
        text = "not found"
        message = {
          channel:channel_id,
          text:"入力されたタスクが見つかりません:face_with_monocle:\n>" + text,
          as_user:false
        }
        expect(Message.delete_message(text,channel_id)).to eq(message)
      end
    end

    context 'when task is found' do
      it 'delete designated task' do
        FactoryBot.create(:task,completed:false,task_name:"deleted")
        text = "deleted"
        message = {
          channel:channel_id,
          text:"入力されたタスクを削除しました:+1:\n>" + text,
          as_user:false
        }
        expect(Message.delete_message(text,channel_id)).to eq(message)
      end
    end
  end

  describe '#complete_message' do
    context 'when not found task' do
      it 'message correct' do
        text = "not found"
        message = {
          channel:channel_id,
          text:"入力されたタスクが見つかりません:face_with_monocle:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,channel_id)).to eq(message)
      end
    end

    context 'when already task is complete' do
      it 'already completed' do
        FactoryBot.create(:task,completed:true,task_name:"completed")
        text = "completed"
        message = {
          channel:channel_id,
          text:"入力されたタスクのステータスはすでに「完了」になってます:man-gesturing-no:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,channel_id)).to eq(message)
      end
    end

    context 'when already task is complete' do
      it 'change to completion' do
        FactoryBot.create(:task,completed:false,task_name:"complete")
        text = "complete"
        message = {
          channel:channel_id,
          text:"入力されたタスクのステータスを「完了」に変更しました:+1:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,channel_id)).to eq(message)
      end
    end
  end

  describe '#add_message' do
    context 'no option' do
      it 'add message' do
        text = 'addアクション追加'
        message = {
          channel:channel_id,
          text:"下記のタスクを追加しました\n>>>" + text,
          as_user:false
        }
        expect(Message.add_message(text,channel_id,user_id)).to eq(message)
      end
    end
    context 'attach option' do
      it 'set due_date' do
        text = 'addアクション追加 due:20180909'
        message = {
          channel:channel_id,
          text:"下記のタスクを追加しました\n>>>" + text,
          as_user:false
        }
        Message.add_message(text,channel_id,user_id)
        expect(Task.pluck(:due_date)[0]).to eq('2018-09-09 00:00:00.000000000 +0000')
      end
      it 'task_name no space' do
        text = 'addアクション追加 due:20180909'
        message = {
          channel:channel_id,
          text:"下記のタスクを追加しました\n>>>" + text,
          as_user:false
        }
        Message.add_message(text,channel_id,user_id)
        expect(Task.first.task_name).to eq('addアクション追加')
      end
    end
  end

  describe '#show_result' do
    context 'when task empty' do
      it 'task is not registered' do
        message = {
          channel:channel_id,
          text:"タスクが登録されていません",
          as_user:false
        }
        expect(Message.show_result(user_id,channel_id)).to eq(message)
      end
    end
    context 'when task not empty' do
      it 'show reult correct' do
        FactoryBot.create(:task)
        message = {
          channel:channel_id,
          text:"タスク一覧\n>・test",
          as_user:false
        }
        expect(Message.show_result(user_id,channel_id)).to eq(message)
      end
    end
  end

  describe '#template' do
    it 'is template correct' do
      text = "test"
      message = {
        channel:channel_id,
        text: text,
        as_user: false
      }
      expect(Message.template(channel_id,text)).to eq(message)
    end
  end

  describe '#help' do
    it 'is help message correct' do
      message = {
        channel:channel_id,
        text: help_text,
        as_user: false
      }
      expect(Message.help(channel_id)).to eq(message)
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
