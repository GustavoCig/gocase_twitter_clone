class RelationController < ApplicationController
  def follow
    @following_user = current_user
    @followed_user = User.find params[:id]
    if @following_user.follows? @followed_user
      @following_user.unfollow @followed_user.username
    else
      @following_user.follow @followed_user.username
    end
    render 'shared/_follow'
  end
end
