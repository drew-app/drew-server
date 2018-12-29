Rails.application.routes.draw do
  root 'home#index'
  scope '/api' do
    resources :tasks, only: [:index, :create, :update, :show]
    resources :tags, only: [:index]
  end
end
