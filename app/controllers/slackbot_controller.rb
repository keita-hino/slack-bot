require 'slack-ruby-client'
require 'slack-ruby-bot'
class SlackbotController < ApplicationController
  def callback
    @body = JSON.parse(request.body.read)
    return if @body['event']['username'] == 'bot'
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
        as_user: false
      )
      head :ok
    end
  end
  def report
    Slack.configure do |config|
      config.token = ENV['SLACK_BOT_USER_TOKEN']
      raise 'Missing ENV[SLACK_BOT_USER_TOKEN]!' unless config.token
    end

    client = Slack::Web::Client.new
    message = Command.report(params['channel_id'])
    client.chat_postMessage(message)
    head :ok
  end
end
