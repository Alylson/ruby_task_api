Rails.application.routes.draw do
  resources :tasks, only: %i[index create show update destroy]
  root "tasks#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
