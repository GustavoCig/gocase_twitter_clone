module IndexHelper
  def like_button tweet
    if current_user.liked? tweet
      link_to 'liked', tweet_like_path(id: tweet), { id: 'like-' + tweet.id.to_s, remote: true }
    else
      link_to 'like', tweet_like_path(id: tweet), { id: 'like-' + tweet.id.to_s, remote: true }
    end
  end

  def follow_link passed_user
    if !(current_user.id == passed_user.id)
      if current_user.follows? passed_user
        link_to 'following', user_follow_path(id: passed_user), { id: 'follow-' + passed_user.id.to_s, remote: true }
      else
        link_to 'follow', user_follow_path(id: passed_user), { id: 'follow-' + passed_user.id.to_s, remote: true }
      end
    end
  end
end