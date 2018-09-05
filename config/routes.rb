Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user"}
  devise_scope :user do
    unauthenticated do
      root :to => 'devise/sessions#create'
    end

    authenticated do
      root :to => 'user#index'
      get '/edit/' => 'user#edit', as: :edit_custom
      get '/logout/' => 'devise/sessions#destroy', as: :logout

    end
  end
end
