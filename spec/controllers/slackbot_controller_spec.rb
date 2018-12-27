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
        user_id:      'C0XXXX',
        user_name:    'user_name',
        command:      '/task_add',
        text:         'addコマンド作成',
        response_url: 'https://example.com'
      }
      expect(response).to have_http_status(:success)
    end
  end
  describe '#show' do
    it 'is task show correct' do
      VCR.use_cassette("controller/show/post_show_success") do
        post :show,params: {
          token:        'token',
          team_id:      'team_id',
          team_domain:  'team_domain',
          channel_id:   'CEN70LSTT',
          channel_name: 'channel_name',
          user_id:      'C0XXXX',
          user_name:    'user_name',
          command:      '/task_add',
          text:         'addコマンド作成',
          response_url: 'https://example.com'
        }
      end
      expect(response).to have_http_status(:success)
    end
  end

end
