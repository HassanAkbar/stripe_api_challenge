Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post('/v1/webhook', to: 'v1/webhook#create')

  # Defines the root path route ("/")
  # root "articles#index"
end
