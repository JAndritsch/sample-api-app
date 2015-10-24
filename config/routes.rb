Rails.application.routes.draw do
  resources :users, :only => [:create]
  resource :sessions, :only => [:create, :destroy]
end
