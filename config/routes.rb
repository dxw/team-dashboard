Rails.application.routes.draw do
  root 'projects#index'

  resources :support_rotations, only: [:index]

  get "/check", to: proc { [200, {}, ["OK"]] }
end
