Slack.configure do |config|
  config.token = ENV['SLACK_BOT_USER_TOKEN']
  raise 'Missing ENV[SLACK_BOT_USER_TOKEN]!' unless config.token
end
