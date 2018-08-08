Rails.application.routes.draw do
  root 'home#index'
  scope '/api' do
    resources :tasks, only: [:index, :create]
  end
end
