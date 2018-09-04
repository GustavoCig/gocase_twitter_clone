Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user"}
  devise_scope :user do
    get '/logout/' => 'devise/sessions#destroy'

    unauthenticated do
      root :to => 'devise/sessions#create'
    end

    authenticated do
      root :to => 'user#index'
    end
  end
end
