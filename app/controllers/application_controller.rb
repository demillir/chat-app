class ApplicationController < ActionController::Base
  before_action :require_sign_in

  def current_user
    @_current_user ||= find_current_user
  end

  private

  def require_sign_in
    unless session[:user_name].present?
      flash[:notice] = "You must sign in to chat"
      redirect_to new_user_path
    end
  end

  def find_current_user
    current_user_name = session[:user_name]
    return nil unless current_user_name.present?

    ActiveUserDB.instance[current_user_name]
  end
end
