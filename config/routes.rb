Rails.application.routes.draw do
  resources :service_times
    get "tasks/update"

    get "tasks/status"

    get "tasks/timer"

    get "tasks/halt"

    get "tasks/refreshable"
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
