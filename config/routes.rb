Rails.application.routes.draw do
  root 'projects#index'

  get "/check", to: proc { [200, {}, ["OK"]] }
end
