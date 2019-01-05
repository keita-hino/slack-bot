require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:today) {Time.now.midnight}
  describe '#today_create_task' do
    it 'return create task list' do
      FactoryBot.create(:task,created_at:today)
      expect(Task.today_create_task.count).to eq(1)
    end
  end

  describe '#today_completed_task' do
    it 'return complete task list' do
      FactoryBot.create(:task,updated_at:today,completed:true)
      expect(Task.today_completed_task.count).to eq(1)
    end
  end

  describe '#incomplete_task' do
    it 'return incomplete task list' do
      FactoryBot.create(:task,created_at:today,completed:false)
      expect(Task.incomplete_task.count).to eq(1)
    end
  end

  describe '#started_task' do
    context 'when started value is true and completed value is false' do
      it 'return 1' do
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
    context 'when started option' do
      it 'started value true' do
        FactoryBot.create(:task,task_name:"test",started:false)
        text = 'test started:'
        expect(Task.modify_task(text)).to be_truthy
      end
    end
  end
end
