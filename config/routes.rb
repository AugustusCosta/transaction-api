Rails.application.routes.draw do
  resources :transactions, only: [:update, :create, :index, :show]
end
