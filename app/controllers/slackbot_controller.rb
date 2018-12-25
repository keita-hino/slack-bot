require 'slack-ruby-client'
require 'slack-ruby-bot'
class SlackbotController < ApplicationController
  def callback
    @body = JSON.parse(request.body.read)
    case @body['type']
    when 'url_verification'
      render json: @body
      @body = JSON.parse(request.body.read)
    when 'event_callback'
      Slack.configure do |config|
        config.token = ENV['SLACK_BOT_USER_TOKEN']
        raise 'Missing ENV[SLACK_BOT_USER_TOKEN]!' unless config.token
      end
      # binding.pry
      client = Slack::Web::Client.new
      client.chat_postMessage(
        channel: @body['event']['channel'],
        text: @body['event']['text'],
        as_user: true
      )
      head :ok
    end
  end
end
