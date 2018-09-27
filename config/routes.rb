Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user"}
  devise_scope :user do
    unauthenticated do
      root :to => 'devise/sessions#create'
    end

    authenticated do
      root :to => 'user#index'

      resource :tweets
      resource :mentions
      resource :user
      get '/edit/' => 'user#edit', as: :edit_custom
      get '/logout/' => 'devise/sessions#destroy', as: :logout
      get '/tweet/:id/like' => 'tweet#like',  as: :tweet_like
      get '/users/:id/follow' => 'relation#follow', as: :user_follow
      get '/timeline/render' => 'user#reload_timeline', as: :reload_timeline
      get '/timeline/loadmore/:page' => 'user#loadmore_timeline'
      get '/timeline/' => 'user#timeline_tab', as: :timeline
    end
  end
end
