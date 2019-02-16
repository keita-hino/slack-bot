require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:today) {Time.now.midnight}
  let(:user_id) {'U999999'}
  describe '#today_create_task' do
    it 'return create task list' do
      FactoryBot.create(:task,created_at:today)
      expect(Task.today_create_task.count).to eq(1)
    end
  end

  describe '#show_task' do
    context ':rangeオプションがついてる時' do
      it 'その日に作成されたタスクを返す' do
        FactoryBot.create(:task,task_name:"today_task",created_at:Date.today)
        FactoryBot.create(:task,task_name:"not_today",created_at:Date.today - 1)
        text = 'range:today'
        expect(Task.show_task(text,user_id).count).to eq(1)
      end
    end

    context 'オプションがない時' do
      it '全てのタスクを返す' do
        FactoryBot.create(:task,task_name:"today_task",created_at:Date.today)
        FactoryBot.create(:task,task_name:"not_today",created_at:Date.today - 1)
        expect(Task.show_task(user_id).count).to eq(2)
      end
    end
  end

  describe '#today_completed_task' do
    it 'その日に完了したタスクを返す' do
      FactoryBot.create(:task,updated_at:today,completed:true)
      expect(Task.today_completed_task.count).to eq(1)
    end
  end

  describe '#incomplete_task' do
    it '期限当日のタスクを返す' do
      FactoryBot.create(:task,created_at:today,completed:false)
      expect(Task.incomplete_task.count).to eq(1)
    end
  end

  describe '#started_task' do
    context 'タスクが未着手かつ、未完了の時' do
      it '1件を返す' do
        FactoryBot.create(:task,created_at:today,completed:false,started:true)
        expect(Task.started_task.count).to eq(1)
      end
    end

    context 'when started value is true and completed value is true' do
      it 'return 0' do
        FactoryBot.create(:task,created_at:today,completed:true,started:true)
        expect(Task.started_task.count).to eq(0)
      end
    end
  end

  describe '#modify_task' do
    context 'when started option attached' do
      it 'started value true' do
        FactoryBot.create(:task,task_name:"test",started:false)
        text = 'test started:'
        expect(Task.modify_task(text)).to be_truthy
      end
    end

    context 'when started option not attached' do
      it 'started value false' do
        FactoryBot.create(:task,task_name:"test",started:false)
        text = 'test'
        expect(Task.modify_task(text)).to be_falsey
      end
    end
  end
end
