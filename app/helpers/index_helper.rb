module IndexHelper
  def like_button(tweet)
    if current_user.liked? tweet
      link_to 'liked', tweet_like_path(id: tweet), { id: 'like-' + tweet.id.to_s, remote: true }
    else
      link_to 'like', tweet_like_path(id: tweet), { id: 'like-' + tweet.id.to_s, remote: true }
    end
  end
end