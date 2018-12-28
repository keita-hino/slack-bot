Rails.application.routes.draw do
  post '/add' => 'slackbot#add'
  post '/complete' => 'slackbot#complete'
  post '/show' => 'slackbot#show'
  post '/report' => 'slackbot#report'
  post '/help' => 'slackbot#help'
end
