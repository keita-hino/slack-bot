require 'rails_helper'

RSpec.describe SlackbotController, type: :controller do
  before do
    FactoryBot.create(:task)
  end

  describe '#add' do
    it 'is task add correct' do
      VCR.use_cassette("controller/add/post_success") do
        post :add,params: {
          token:        'token',
          team_id:      'team_id',
          team_domain:  'team_domain',
          channel_id:   'test',
          channel_name: 'channel_name',
          user_id:      'C0XXXX',
          user_name:    'user_name',
          command:      '/task_add',
          text:         'test',
          response_url: 'https://example.com'
        }
      end
      expect(response).to have_http_status(:success)
    end
  end

  describe '#modify' do
    it 'is task modify correct' do
      VCR.use_cassette("controller/modify/post_success") do
        post :modify,params: {
          token:        'token',
          team_id:      'team_id',
          team_domain:  'team_domain',
          channel_id:   'test',
          channel_name: 'channel_name',
          user_id:      'C0XXXX',
          user_name:    'user_name',
          command:      '/task_complete',
          text:         'test',
          response_url: 'https://example.com'
        }
      end
      expect(response).to have_http_status(:success)
    end
  end

  describe '#complete' do
    it 'is task comcomplete correct' do
      VCR.use_cassette("controller/complete/post_success") do
        post :complete,params: {
          token:        'token',
          team_id:      'team_id',
          team_domain:  'team_domain',
          channel_id:   'test',
          channel_name: 'channel_name',
          user_id:      'C0XXXX',
          user_name:    'user_name',
          command:      '/task_complete',
          text:         'test',
          response_url: 'https://example.com'
        }
      end
      expect(response).to have_http_status(:success)
    end
  end

  describe '#report' do
    it 'is task report correct' do
      VCR.use_cassette("controller/report/post_success") do
        post :report,params: {
          token:        'token',
          team_id:      'team_id',
          team_domain:  'team_domain',
          channel_id:   'test',
          channel_name: 'channel_name',
          user_id:      'C0XXXX',
          user_name:    'user_name',
          command:      '/task_complete',
          text:         'test',
          response_url: 'https://example.com'
        }
      end
      expect(response).to have_http_status(:success)
    end
  end

  describe '#delete' do
    it 'is task delete correct' do
      VCR.use_cassette("controller/delete/post_success") do
        post :delete,params: {
          token:        'token',
          team_id:      'team_id',
          team_domain:  'team_domain',
          channel_id:   'test',
          channel_name: 'channel_name',
          user_id:      'C0XXXX',
          user_name:    'user_name',
          command:      '/task_add',
          text:         'test',
          response_url: 'https://example.com'
        }
      end
      expect(response).to have_http_status(:success)
    end
  end

  describe '#show' do
    it 'is task show correct' do
      VCR.use_cassette("controller/show/post_success") do
        post :show,params: {
          token:        'token',
          team_id:      'team_id',
          team_domain:  'team_domain',
          channel_id:   'test',
          channel_name: 'channel_name',
          user_id:      'C0XXXX',
          user_name:    'user_name',
          command:      '/task_add',
          text:         'test',
          response_url: 'https://example.com'
        }
      end
      expect(response).to have_http_status(:success)
    end
  end

end
