Rails.application.routes.draw do
  scope '/api' do
    resources :tasks, only: [:index]
  end
end
