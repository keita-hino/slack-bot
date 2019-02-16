require 'rails_helper'

describe Message do
  let(:channel_id) {'C999999'}
  let(:user_id) {'U999999'}

  describe '#modify_message' do
    context ':startオプション指定時' do
      it 'タスク修正完了のメッセージを返す' do
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

    context 'オプション指定がない時' do
      it 'タスク修正失敗のメッセージを返す' do
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
    it '日報用のメッセージを返す' do
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
    context '作られたタスクが存在しない時' do
      it 'タスク未作成のメッセージを返す' do
        text = "Today-Report\n"
        message = "#{text}\n本日追加されたタスク:new:\n\n>本日登録されたタスクはまだありません\n"

        expect(Message.report_create(text)).to eq(message)
      end
    end
    context '作られたタスクが存在する時' do
      it '作成したタスクのリストを返す' do
        FactoryBot.create(:task,task_name:"create_task")
        text = "Today-Report\n"
        message = "#{text}\n本日追加されたタスク:new:\n\n>create_task"

        expect(Message.report_create(text)).to eq(message)
      end
    end
  end

  describe '#report_complete' do
    context '完了したタスクが存在しない時' do
      it 'タスク未完了のメッセージを返す' do
        text = "Today-Report\n"
        message = "#{text}\n\n本日完了したタスク:ok:\n\n>本日完了したタスクはまだありません\n"

        expect(Message.report_complete(text)).to eq(message)
      end
    end

    context '完了したタスクが存在する時' do
      it '完了したタスクのリストを返す' do
        FactoryBot.create(:task,task_name:"complete_task",completed:true)
        text = "Today-Report\n"
        message = "#{text}\n\n本日完了したタスク:ok:\n\n>complete_task"

        expect(Message.report_complete(text)).to eq(message)
      end
    end
  end

  describe '#report_incomplete' do
    context '期限当日で未完了のタスクがない時' do
      it 'タスクがない旨のメッセージを返す' do
        text = "Today-Report\n"
        message = "#{text}\n\n残タスク:up:\n\n>残タスクはありません\n"

        expect(Message.report_incomplete(text)).to eq(message)
      end
    end

    context '着手中のタスクが存在する時' do
      it '未完了のタスクを返す' do
        FactoryBot.create(:task,task_name:"incomplete_task",completed:false)
        text = "Today-Report\n"
        message = "#{text}\n\n残タスク:up:\n\n>incomplete_task"

        expect(Message.report_incomplete(text)).to eq(message)
      end
    end
  end

  describe '#report_task_started' do
    context '着手中のタスクがない時' do
      it 'タスクがないとき用のメッセージを返す' do
        text = "Today-Report\n"
        message = "#{text}\n\n着手中のタスク:man-running:\n\n>着手中のタスクはありません\n"

        expect(Message.report_task_started(text)).to eq(message)
      end
    end

    context '着手中のタスクが存在する時' do
      it '着手中のタスクを返す' do
        FactoryBot.create(:task,task_name:"started_task",completed:false,started:true)
        text = "Today-Report\n"
        message = "#{text}\n\n着手中のタスク:man-running:\n\n>started_task"

        expect(Message.report_task_started(text)).to eq(message)
      end
    end
  end

  describe '#delete_message' do
    context 'タスクが存在しない時' do
      it 'タスクがないとき用のメッセージを返す' do
        text = "not found"
        message = {
          channel:channel_id,
          text:"入力されたタスクが見つかりません:face_with_monocle:\n>" + text,
          as_user:false
        }
        expect(Message.delete_message(text,channel_id)).to eq(message)
      end
    end

    context 'タスクが存在する時' do
      it '削除完了のメッセージを返す' do
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

    context '複数タスクが存在する時' do
      it '削除完了のメッセージを返す' do
        FactoryBot.create(:task,completed:false,task_name:"deleted")
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
    context 'タスクが存在しない時' do
      it 'タスクがないとき用のメッセージを返す' do
        text = "not found"
        message = {
          channel:channel_id,
          text:"入力されたタスクが見つかりません:face_with_monocle:\n>>>" + text,
          as_user:false
        }
        expect(Message.complete_message(text,channel_id)).to eq(message)
      end
    end

    context 'タスクがすでに完了になっている時' do
      it 'すでに完了になっている旨のメッセージを返す' do
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

    context 'タスクが未完了の時' do
      it '完了メッセージを返す' do
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
    context 'オプションがない時' do
      it 'タスクを追加' do
        text = 'addアクション追加'
        message = {
          channel:channel_id,
          text:"下記のタスクを追加しました\n>>>" + text,
          as_user:false
        }
        expect(Message.add_message(text,channel_id,user_id)).to eq(message)
      end
    end
    context 'オプションがある時' do
      it 'Due Dateとタスク情報を追加' do
        text = 'addアクション追加 due:20180909'
        message = {
          channel:channel_id,
          text:"下記のタスクを追加しました\n>>>" + text,
          as_user:false
        }
        Message.add_message(text,channel_id,user_id)
        expect(Task.pluck(:due_date)[0]).to eq('2018-09-09 00:00:00.000000000 +0000')
      end
      it 'タスク名の後ろに空白が入っていないこと' do
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
    context 'タスクがない時' do
      it 'タスクがないとき用のメッセージを返す' do
        text = "range:week"
        message = {
          channel:channel_id,
          text:"タスクが登録されていません",
          as_user:false
        }
        expect(Message.show_result(text,user_id,channel_id)).to eq(message)
      end
    end
    context 'タスクがある時' do
      it 'タスク情報を返す' do
        FactoryBot.create(:task)
        text = "range:week"
        message = {
          channel:channel_id,
          text:"タスク一覧\n>・test",
          as_user:false
        }
        expect(Message.show_result(text,user_id,channel_id)).to eq(message)
      end

      it 'タスク情報を昇順で返す' do
        FactoryBot.create(:task,task_name:"task2",created_at:Date.today)
        FactoryBot.create(:task,task_name:"task1",created_at:Date.today - 1)
        text = ''
        message = {
          channel:channel_id,
          text: "タスク一覧\n>・task1\n>・task2",
          as_user: false
        }

        expect(Message.show_result(text,user_id,channel_id)).to eq(message)
      end
    end

    context ':rangeオプションがついてる時' do
      it '指定された範囲のタスク情報を返す' do
        FactoryBot.create(:task,task_name:"today_task",created_at:Date.today)
        FactoryBot.create(:task,task_name:"not_today",created_at:Date.today - 1)
        text = 'range:today'
        message = {
          channel:channel_id,
          text: "タスク一覧\n>・today_task",
          as_user: false
        }

        expect(Message.show_result(text,user_id,channel_id)).to eq(message)
      end
    end
  end

  describe '#template' do
    it 'テンプレートを返す' do
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
    it 'ヘルプメッセージを返す' do
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
      /task_show タスク名 range:today
        →タスクの一覧を表示する。rangeオプションを指定することで任意の範囲のタスク一覧を取得することができる。
      /task_report
        →完了したタスクなどから、日報を作成する。
      /task_modify
        →タスクのステータスを変更する。
      /task_help
        →各種コマンドの説明を表示する。
    EOS
  end

end
