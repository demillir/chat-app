class ApplicationController < ActionController::Base
  before_action :require_sign_in

  private

  def require_sign_in
    unless session[:user_name].present?
      flash[:notice] = "You must sign in to chat"
      redirect_to new_user_path
    end
  end
end
