require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#today_create_task' do
    it 'return create task list' do
      today = Time.now.midnight
      FactoryBot.create(:task,created_at:today)
      expect(Task.today_create_task.count).to eq(1)
    end
  end

  describe '#today_completed_task' do
    it 'return complete task list' do
      today = Time.now.midnight
      FactoryBot.create(:task,updated_at:today,completed:true)
      expect(Task.today_completed_task.count).to eq(1)
    end
  end

  describe '#incomplete_task' do
    it 'return incomplete task list' do
      today = Time.now.midnight
      FactoryBot.create(:task,created_at:today,completed:false)
      expect(Task.incomplete_task.count).to eq(1)
    end
  end
end
