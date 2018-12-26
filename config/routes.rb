Rails.application.routes.draw do
  post '/add' => 'slackbot#add'
  post '/report' => 'slackbot#report'
  post '/help' => 'slackbot#help'
end
