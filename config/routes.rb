Rails.application.routes.draw do
  post '/callback' => 'slackbot#callback'
end
