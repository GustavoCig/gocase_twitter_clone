class TweetController < ApplicationController
  def like
    @liking_user = current_user
    @tweet = Tweet.find params[:id]
    if @liking_user.liked? @tweet
      @liking_user.dislike @tweet
    else
      @liking_user.like @tweet
    end
    render 'shared/_like'
  end
end
