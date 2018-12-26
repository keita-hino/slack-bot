require 'rails_helper'

RSpec.describe SlackbotController, type: :controller do
  before do
    FactoryBot.create(:task)
  end

  describe '#add' do
    it 'is task add correct' do
      post :add,params: {
        token:        'token',
        team_id:      'team_id',
        team_domain:  'team_domain',
        channel_id:   'channel_id',
        channel_name: 'channel_name',
        user_id:      'user_id',
        user_name:    'user_name',
        command:      '/task_add',
        text:         'addコマンド作成',
        response_url: 'https://example.com'
      }
      expect(response).to have_http_status(:success)
    end
  end
end
