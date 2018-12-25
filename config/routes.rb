Rails.application.routes.draw do
  post '/callback' => 'slackbot#callback'
  post '/report' => 'slackbot#report'
end
