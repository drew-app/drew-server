Rails.application.routes.draw do
  scope '/api' do
    resources :tasks, only: [:index, :create]
  end
end
