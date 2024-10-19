Rails.application.routes.draw do
  resources :tasks, only: %i[create show update destroy]
  #post 'task/create', to: 'task#create'
  
  # Defina as demais rotas de maneira RESTful
  #resources :tasks, only: %i[show update destroy]

  get "up" => "rails/health#show", as: :rails_health_check

end
