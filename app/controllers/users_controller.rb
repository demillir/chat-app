class UsersController < ApplicationController
  skip_before_action :require_sign_in, only: [:new, :create]

  def index
    @current_user = current_user
    puts '******* CURRENT USER'
    pp current_user
    @chats = ActiveUserDB.instance
               .map    {|name, user| Chat.new(initiator: current_user, partner: user)}
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      result = IntroduceUser.call(user: @user)

      if result.success?
        cookies.signed[:user_name] = @user.name
        redirect_to users_path
      else
        flash.now[:error] = result.message
        render action: :new
      end
    else
      flash.now[:error] = @user.errors.full_messages
      render action: :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
