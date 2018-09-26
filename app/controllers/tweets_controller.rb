class TweetsController < ApplicationController
  def create
    @new_tweet = Tweet.new user: current_user, message: params[:tweet][:message]
    @tweets_reload = Tweet.includes(:user)
                      .where(['(user_id = ?) or (user_id IN (?))', current_user.id, current_user.followed_users.ids])
                      .limit 10
    if @new_tweet.save!
      render 'shared/_timeline'
    else
      render json:{}, status: :internal_server_error
    end
  end
end
