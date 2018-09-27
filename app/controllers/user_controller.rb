class UserController < Devise::RegistrationsController
  before_action :configure_params, only: [:create, :update, :edit]

  def index
    @user = current_user
    @tweets = Tweet.includes(:user)
                .where(['(user_id = ?) or (user_id IN (?))', current_user.id, current_user.followed_users.ids])
                .limit 10
    @followed_users = User.all
    @new_tweet = Tweet.new
  end

  def reload_timeline
    @tweets_reload = Tweet.includes(:user)
                      .where(['(user_id = ?) or (user_id IN (?))', current_user.id, current_user.followed_users.ids])
                      .limit 10
    render 'shared/_timeline'
  end

  def loadmore_timeline
    @tweets_reload = Tweet.includes(:user)
                      .where(['(user_id = ?) or (user_id IN (?))', current_user.id, current_user.followed_users.ids])
                      .limit(1)
                      .offset 1 * params[:page].to_i
    puts @tweets_reload
    if @tweets_reload.empty?
      render json: { message: "No more content to be loaded" }, status: 416
    else
      render 'shared/_loadmore_timeline'
    end
  end

  def timeline_tab
    @user = current_user
    @tweets = Tweet.includes(:user)
                .where(['(user_id = ?) or (user_id IN (?))', current_user.id, current_user.followed_users.ids])
                .limit 10
    @followed_users = User.all
    @new_tweet = Tweet.new
    render 'shared/_main_timeline'
  end

  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
   def update
     super
     puts params[:user][:avatar]
   end

  # DELETE /resource
   def destroy
     super
   end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
   def cancel
     super
   end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_params
    devise_parameter_sanitizer.permit :sign_up, keys: [:name, :username, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :account_update, keys: [:avatar, :name, :email, :password, :password_confirmation]
  end
end
