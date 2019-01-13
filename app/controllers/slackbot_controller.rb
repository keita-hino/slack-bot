require 'slack-ruby-client'
require 'slack-ruby-bot'

class SlackbotController < ApplicationController
  before_action :slack_init, only: [:report, :help, :add, :show, :complete, :delete, :modify]
  def add
    message = Message.add_message(params['text'],params['channel_id'],params['user_id'])
    @client.chat_postMessage(message)
  end

  def complete
    message = Message.complete_message(params['text'],params['channel_id'])
    @client.chat_postMessage(message)
  end

  def modify
    message = Message.modify_message(params['text'],params['channel_id'])
    @client.chat_postMessage(message)
  end

  def delete
    message = Message.delete_message(params['text'],params['channel_id'])
    @client.chat_postMessage(message)
  end

  def show
    message = Message.show_result(params['text'],params['user_id'],params['channel_id'])
    @client.chat_postMessage(message)
    head :ok
  end

  def report
    message = Message.report_message(params['channel_id'])
    @client.chat_postMessage(message)
    head :ok
  end

  def help
    message = Message.help(params['channel_id'])
    @client.chat_postMessage(message)
    head :ok
  end

  def slack_init
    Slack.configure do |config|
      config.token = ENV['SLACK_BOT_USER_TOKEN']
      raise 'Missing ENV[SLACK_BOT_USER_TOKEN]!' unless config.token
    end
    @client = Slack::Web::Client.new
  end
end
