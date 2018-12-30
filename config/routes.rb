Rails.application.routes.draw do
  root 'home#index'
  scope '/api' do
    resources :tasks, only: [:index, :create, :update, :show]
    resources :tags, only: [:index]
    resources :trackers, only: [:index, :create]
  end
end
