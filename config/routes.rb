Rails.application.routes.draw do
  post '/report' => 'slackbot#report'
  post '/help' => 'slackbot#help'
end
