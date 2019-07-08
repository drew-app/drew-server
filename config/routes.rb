Rails.application.routes.draw do
  root 'home#index'
  scope '/api' do
    resources :tasks, only: [:index, :create, :update, :show]
    resources :tags, only: [:index]
    resources :trackers, only: [:index, :create, :show, :destroy] do
      resources :tracker_records, only: [:index, :create]
    end
  end
end
