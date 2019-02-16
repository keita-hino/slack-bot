require 'rails_helper'

RSpec.describe SlackbotController, type: :controller do
  before do
    FactoryBot.create(:task)
  end

  describe 'POST#add' do
    it 'successを返す' do
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

  describe 'POST#modify' do
    it 'successを返す' do
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

  describe 'POST#complete' do
    it 'successを返す' do
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

  describe 'POST#report' do
    it 'successを返す' do
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

  describe 'POST#delete' do
    it 'successを返す' do
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

  describe 'POST#show' do
    it 'successを返す' do
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
