Rails.application.routes.draw do
  resources :users, :only => [:create, :index, :show]
  resource :sessions, :only => [:create, :destroy]
end
