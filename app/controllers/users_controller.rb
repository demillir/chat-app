class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      session[:user_name] = @user.name
      redirect_to users_path
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
