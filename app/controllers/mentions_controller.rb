class MentionsController < ApplicationController
  def show
    mentions = Mention.includes(:tweet)
                          .where(user_id: current_user.id)
                          .pluck(:tweet_id)
    @mentioned_tweets = Tweet.find(mentions)
    render 'shared/_load_mentions'
  end
end
