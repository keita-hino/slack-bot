Rails.application.routes.draw do
  root 'tasks#index'
  post '/tasks/:id' => 'tasks#update'
  resources :tasks, only: [:show,:index,:new,:create,:edit]
  post '/add' => 'slackbot#add'
  post '/complete' => 'slackbot#complete'
  post '/delete' => 'slackbot#delete'
  post '/show' => 'slackbot#show'
  post '/report' => 'slackbot#report'
  post '/help' => 'slackbot#help'
  post '/modify' => 'slackbot#modify'
end
