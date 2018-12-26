require 'slack-ruby-client'
require 'slack-ruby-bot'

class SlackbotController < ApplicationController
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
  def help
    Slack.configure do |config|
      config.token = ENV['SLACK_BOT_USER_TOKEN']
      raise 'Missing ENV[SLACK_BOT_USER_TOKEN]!' unless config.token
    end
    client = Slack::Web::Client.new
    message = Command.help(params['channel_id'])
    client.chat_postMessage(message)
  end
end
