require 'slack-ruby-client'
require 'slack-ruby-bot'

class SlackbotController < ApplicationController
  before_action :slack_init, only: [:report, :help, :add, :show, :complete, :delete]
  def add
    Task.create(
      user_id:params['user_id'],
      task_name:params['text']
    )
    message = Message.add_message(params['text'],params['channel_id'])
    @client.chat_postMessage(message)
  end

  def complete
    message = Message.complete_message(params['text'],params['channel_id'])
    @client.chat_postMessage(message)
  end

  def delete
    message = Message.delete_message(params['text'],params['channel_id'])
    @client.chat_postMessage(message)
  end

  def show
    message = Message.show_result(params['user_id'],params['channel_id'])
    @client.chat_postMessage(message)
    head :ok
  end

  def report
    message = Message.template(params['channel_id'],"成功")
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
